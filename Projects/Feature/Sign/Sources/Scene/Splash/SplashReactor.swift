import AuthInterface

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
  
  private let autoSignUseCase: AutoSignUseCaseInterface

  init(
    autoSignUseCase: AutoSignUseCaseInterface
  ) {
    self.autoSignUseCase = autoSignUseCase
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .onAppear:
        .task {
          try await autoSignUseCase.execute()
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
