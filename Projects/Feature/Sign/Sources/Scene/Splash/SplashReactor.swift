import Core

import ReactorKit

final class SplashReactor: Reactor {

  enum Action {
    case onAppear
  }

  enum Mutation {
    case setDestination(Destination)
    case setAlert
  }

  enum Destination {
    case login
    case main
  }

  struct State {
    @Pulse var destination: Destination?
    @Pulse var isUpdateAlert: Bool = false
  }

  let initialState: State = State()
  private let signRepository: SignRepositoryInterface
  private let userRepo: UserRepositoryInterface
  private let versionRepo: VersionRepositoryInterface

  init(
    signRepository: SignRepositoryInterface,
    userRepo: UserRepositoryInterface,
    versionRepo: VersionRepositoryInterface
  ) {
    self.signRepository = signRepository
    self.userRepo = userRepo
    self.versionRepo = versionRepo
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .onAppear:
        .task {
          try await versionRepo.get()
          let result = try await signRepository.autoSign()
          _ = try await userRepo.user()
          return result
        }
        .map { .setDestination($0.schoolInfoProvided ? .main : .login) }
        .catch { error in
          if error.localizedDescription == "앱 업데이트가 필요합니다." {
            return .just(.setAlert)
          } else {
            return .just(.setDestination(.login))
          }
        }
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setDestination(let destination):
      newState.destination = destination
    case .setAlert:
      newState.isUpdateAlert = true
    }
    return newState
  }
}
