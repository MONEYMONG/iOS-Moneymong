import Foundation

import NetworkService

import ReactorKit

final class LedgerScanCreaterReactor: Reactor {
  var initialState: State = State()
  
  enum Action {
    case appear
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
    @Pulse var imageData: Data?
    @Pulse var isLoading: Bool = false
    @Pulse var error: MoneyMongError?
    @Pulse var destination: Destination?
    
    enum Destination {
      case scanResult(OCRResult)
    }
  }
  
  private let ledgerRepo: LedgerRepositoryInterface

  init(
    ledgerRepo: LedgerRepositoryInterface
  ) {
    self.ledgerRepo = ledgerRepo
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .appear:
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
    return .task {
      //return try await ledgerRepo.fetchOCR(data)
      try await Task.sleep(nanoseconds: 3_000_000_000)
      return OCRResult(source: "가", amount: "1,000", date: ["2024", "04", "04"], time: ["11", "11", "11"])
    }
    .map { .setDestination(.scanResult($0)) }
    .catch {
      return .just(.setError($0.toMMError))
    }
  }
}
