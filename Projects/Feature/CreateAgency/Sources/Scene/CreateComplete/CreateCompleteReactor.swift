import BaseFeature

import UserInterface

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
  
  private let updateSelectedAgencyUseCase: UpdateSelectedAgencyUseCaseInterface
  
  let initialState: State
  
  init(
    updateSelectedAgencyUseCase: UpdateSelectedAgencyUseCaseInterface,
    id: Int
  ) {
    self.updateSelectedAgencyUseCase = updateSelectedAgencyUseCase
    self.initialState = .init(agencyID: id)
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    updateSelectedAgencyUseCase.execute(id: currentState.agencyID)
    switch action {
    case .tapDismiss:
      return .just(.setDestination(.dismiss))
    case .tapLedger:
      return .just(.setDestination(.ledger))
    case .tapOperatingCost:
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
