import BaseFeature

import NetworkService

import ReactorKit

final class CreateCompleteReactor: Reactor {
  struct State {
    let agencyID: Int
    @Pulse var destination: Destination?
    
    enum Destination {
      case ledger
      case manualInput
      case dismiss
    }
  }
  
  enum Action {
    case tapDismiss
    case tapLedger
    case tapOperatingCost
  }
  
  enum Mutation {
    case setDestination(State.Destination)
  }
  
  private let userRepo: UserRepositoryInterface
  
  let initialState: State
  
  init(userRepo: UserRepositoryInterface, id: Int) {
    self.userRepo = userRepo
    self.initialState = .init(agencyID: id)
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .tapDismiss:
      return .just(.setDestination(.dismiss))
    case .tapLedger:
      userRepo.updateSelectedAgency(id: currentState.agencyID)
      return .just(.setDestination(.ledger))
    case .tapOperatingCost:
      userRepo.updateSelectedAgency(id: currentState.agencyID)
      return .just(.setDestination(.manualInput))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setDestination(destination):
      newState.destination = destination
    }
    return newState
  }
}
