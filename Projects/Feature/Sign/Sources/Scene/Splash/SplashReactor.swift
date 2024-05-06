import NetworkService

import ReactorKit

final class SplashReactor: Reactor {

  enum Action {
    case onAppear
  }

  enum Mutation {
    case setDestination(Destination)
  }

  enum Destination {
    case login
    case main
  }

  struct State {
    @Pulse var destination: Destination?
  }

  let initialState: State = State()
  private let signRepository: SignRepositoryInterface

  init(signRepository: SignRepositoryInterface) {
    self.signRepository = signRepository
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .onAppear:
      return .task {
        return try await signRepository.autoSign()
      }
      .map { .setDestination($0.loginSuccess ? .main : .login) }
      .catch { _ in .just(.setDestination(.login)) }
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
