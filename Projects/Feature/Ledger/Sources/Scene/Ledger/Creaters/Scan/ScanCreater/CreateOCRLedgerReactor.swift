import Foundation

import BaseDomain
import LedgerInterface
import Utility

import ReactorKit

final class CreateOCRLedgerReactor: Reactor {
  var initialState: State
  
  enum Action {
    case onAppear
    case receiptShoot(Data?)
    case onError(MoneyMongError)
  }
  
  enum Mutation {
    case setTake(Bool)
    case setLoading(Bool)
    case setError(MoneyMongError)
    case setDestination(State.Destination)
  }
  
  struct State {
    let agencyId: Int
    @Pulse var isTook: Bool = false
    @Pulse var isLoading: Bool = false
    @Pulse var error: MoneyMongError?
    @Pulse var destination: Destination?
    
    enum Destination {
      case scanResult(Int, model: OCRResult, imageData: Data)
    }
  }
  
  private let receiptOCRUseCase: ReceiptOCRUseCaseInterface

  init(
    agencyId: Int,
    receiptOCRUseCase: ReceiptOCRUseCaseInterface
  ) {
    self.receiptOCRUseCase = receiptOCRUseCase
    self.initialState = State(agencyId: agencyId)
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .receiptShoot(let data):
        .concat([
          .just(.setTake(true)),
          .just(.setLoading(true)),
          requsetOCR(data),
          .just(.setLoading(false))
        ])
    case let .onError(error):
        .just(.setError(error))
    case .onAppear:
        .just(.setTake(false))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    newState.error = nil
    switch mutation {
    case let .setLoading(isLoading):
      newState.isLoading = isLoading
    case let .setError(error):
      newState.error = error
    case let .setDestination(destination):
      newState.destination = destination
    case let .setTake(isTook):
      newState.isTook = isTook
    }
    return newState
  }
  
  private func requsetOCR(_ data: Data?) -> Observable<Mutation> {
    guard let data else { return .empty() }
    let agencyId = currentState.agencyId
    return .task {
      let model = try await receiptOCRUseCase.execute(imageData: data)
      if model.inferResult == "ERROR" {
        throw MoneyMongError.appError(.default, errorMessage: "영수증이 보이도록 정확하게 촬영해주세요")
      } else {
        return model
      }
    }
    .map { .setDestination(.scanResult(agencyId, model: $0, imageData: data)) }
    .catch {
      return .just(.setError($0.toMMError))
    }
  }
}
