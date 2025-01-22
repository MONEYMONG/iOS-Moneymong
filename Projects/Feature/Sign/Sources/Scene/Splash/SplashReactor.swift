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
  private let tokenRepo: TokenRepositoryInterface
  private let versionRepo: VersionRepositoryInterface

  init(
    signRepository: SignRepositoryInterface,
    tokenRepo: TokenRepositoryInterface,
    versionRepo: VersionRepositoryInterface
  ) {
    self.signRepository = signRepository
    self.tokenRepo = tokenRepo
    self.versionRepo = versionRepo
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .onAppear:
        .task {
          try await versionRepo.get()
          try await tokenRepo.token()
        }
        .map { .setDestination(.main) }
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
