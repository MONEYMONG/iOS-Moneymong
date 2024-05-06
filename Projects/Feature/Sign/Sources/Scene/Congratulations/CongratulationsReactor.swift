import ReactorKit

final class CongratulationsReactor: Reactor {
  enum Action {
    case confirm
  }

  enum Mutation {
    case setDestination(Destination)
  }

  enum Destination {
    case main
  }

  struct State {
    @Pulse var destination: Destination?
  }

  let initialState: State = State()

  init() {}

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .confirm:
      return .just(.setDestination(.main))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setDestination(let destination):
      newState.destination = destination
    }
    return newState
  }
}
