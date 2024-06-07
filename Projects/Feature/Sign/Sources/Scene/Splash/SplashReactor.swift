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
  private let userRepo: UserRepositoryInterface

  init(signRepository: SignRepositoryInterface, userRepo: UserRepositoryInterface) {
    self.signRepository = signRepository
    self.userRepo = userRepo
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .onAppear:
      return .task {
        let result = try await signRepository.autoSign()
        _ = try await userRepo.user()
        return result
      }
      .map { .setDestination($0.schoolInfoExist ? .main : .login) }
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
