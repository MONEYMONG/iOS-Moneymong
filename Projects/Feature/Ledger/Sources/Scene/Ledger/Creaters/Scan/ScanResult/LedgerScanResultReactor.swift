import Foundation
import UIKit

import NetworkService

import ReactorKit

final class LedgerScanResultReactor: Reactor {
  enum Action {
    case onAppear
    case didTapCompleteButton
    case didTapEditButton
  }
  
  enum Mutation {
    case setDestination(State.Destination)
    case setError(MoneyMongError)
    case setSuccess(Bool)
  }
  
  struct State {
    let agencyId: Int
    @Pulse var receiptImageData: Data
    @Pulse var source: String
    @Pulse var money: String
    @Pulse var date: [String]
    @Pulse var time: [String]
    @Pulse var destination: Destination?
    @Pulse var isSuccess: Bool = true
    @Pulse var error: MoneyMongError?
    
    enum Destination {
      case ledger
      case manualCreater(Int, OCRResult, Data)
    }
  }
  
  let initialState: State
  private let service: LedgerServiceInterface
  private let repo: LedgerRepositoryInterface
  private let ocrModel: OCRResult
  private let formatter = ContentFormatter()
  
  init(
    agencyId: Int,
    model: OCRResult,
    imageData: Data,
    repo: LedgerRepositoryInterface,
    ledgerService: LedgerServiceInterface
  ) {
    self.repo = repo
    self.service = ledgerService
    self.ocrModel = model
    self.initialState = State(
      agencyId: agencyId,
      receiptImageData: imageData,
      source: model.source,
      money: model.amount,
      date: model.date,
      time: model.time
    )
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .didTapCompleteButton:
      return .concat([
        requestCreateLedgerRecord(),
        service.ledgerList.createLedgerRecord().flatMap { _ in
          Observable<Mutation>.empty()
        }
      ])
    case .onAppear:
      return .just(.setSuccess(isSuccessOCR(ocrModel)))
    case .didTapEditButton:
      return .just(.setDestination(
        .manualCreater(
          currentState.agencyId,
          ocrModel,
          currentState.receiptImageData
        )
      ))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    newState.error = nil
    switch mutation {
    case let .setDestination(destination):
      newState.destination = destination
    case let .setError(error):
      newState.error = error
    case let .setSuccess(value):
      newState.isSuccess = value
    }
    return newState
  }
}

private extension LedgerScanResultReactor {
  func requestCreateLedgerRecord() -> Observable<Mutation> {
    return .task {
      guard let amount = Int(currentState.money.filter { $0.isNumber }) else {
        throw MoneyMongError.appError(errorMessage: "금액을 확인해 주세요")
      }
      guard let date = formatter.mergeWithISO8601(
        date: currentState.date.joined(separator: "/"),
        time: currentState.time.joined(separator: ":")
      )
      else {
        throw MoneyMongError.appError(errorMessage: "날짜 및 시간을 확인해 주세요")
      }
      guard let resizeImageData = UIImage(data: currentState.receiptImageData)?.jpegData(compressionQuality: 0.33) else {
        throw MoneyMongError.appError(errorMessage: "영수증 이미지를 확인해 주세요")
      }
      let imageURL = try await repo.imageUpload(resizeImageData).url
      return try await repo.create(
        id: currentState.agencyId,
        storeInfo: currentState.source,
        fundType: .expense,
        amount: amount,
        description: "내용없음",
        paymentDate: date,
        receiptImageUrls: [imageURL],
        documentImageUrls: []
      )
    }
    .map { .setDestination(.ledger) }
    .catch {
      return .just(.setError($0.toMMError))
    }
  }
  
  func isSuccessOCR(_ model: OCRResult) -> Bool {
    if model.source.isEmpty { return false }
    if model.amount.isEmpty { return false }
    for date in model.date {
      if date.isEmpty { return false }
    }
    for time in model.time {
      if time.isEmpty { return false }
    }
    return true
  }
}
