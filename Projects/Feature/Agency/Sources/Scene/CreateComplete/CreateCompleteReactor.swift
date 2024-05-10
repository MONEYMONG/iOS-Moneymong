import ReactorKit

final class CreateCompleteReactor: Reactor {
  struct State {
    @Pulse var destination: Destination?
    
    enum Destination {
      case ledger
      case registerLedger
    }
  }
  
  enum Action {
    case tapLedger
    case tapRegisterLedger
  }
  
  enum Mutation {
    case setDestination(State.Destination)
  }
  
  let initialState = State()
  
  init() { }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .tapLedger:
      return .just(.setDestination(.ledger))
    case .tapRegisterLedger:
      return .just(.setDestination(.registerLedger))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setDestination(value):
      newState.destination = value
    }
    
    return newState
  }
}
