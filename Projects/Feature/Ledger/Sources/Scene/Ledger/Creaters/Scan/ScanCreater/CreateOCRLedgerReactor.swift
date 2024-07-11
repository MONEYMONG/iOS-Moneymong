import Foundation

import Core

import ReactorKit

final class CreateOCRLedgerReactor: Reactor {
  var initialState: State
  
  enum Action {
    case onAppear
    case receiptShoot(Data?)
    case onError(MoneyMongError)
  }
  
  enum Mutation {
    case setImageData(Data?)
    case setLoading(Bool)
    case setError(MoneyMongError)
    case setDestination(State.Destination)
  }
  
  struct State {
    let agencyId: Int
    @Pulse var imageData: Data?
    @Pulse var isLoading: Bool = false
    @Pulse var error: MoneyMongError?
    @Pulse var destination: Destination?
    
    enum Destination {
      case scanResult(Int, model: OCRResult, imageData: Data)
    }
  }
  
  private let ledgerRepo: LedgerRepositoryInterface

  init(
    agencyId: Int,
    ledgerRepo: LedgerRepositoryInterface
  ) {
    self.ledgerRepo = ledgerRepo
    self.initialState = State(agencyId: agencyId)
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .onAppear:
        .just(.setImageData(nil))
    case .receiptShoot(let data):
        .concat([
          .just(.setImageData(data)),
          .just(.setLoading(true)),
          requsetOCR(data),
          .just(.setLoading(false))
        ])
    case let .onError(error):
        .just(.setError(error))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    newState.error = nil
    switch mutation {
    case let .setImageData(data):
      newState.imageData = data
    case let .setLoading(isLoading):
      newState.isLoading = isLoading
    case let .setError(error):
      newState.error = error
    case let .setDestination(destination):
      newState.destination = destination
    }
    return newState
  }
  
  private func requsetOCR(_ data: Data?) -> Observable<Mutation> {
    guard let data else { return .empty() }
    let agencyId = currentState.agencyId
    return .task {
      let model = try await ledgerRepo.fetchOCR(data)
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
