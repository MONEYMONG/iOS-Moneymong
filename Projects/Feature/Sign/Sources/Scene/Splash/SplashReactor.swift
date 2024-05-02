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
      return Observable.create { [unowned self] observer in
        Task {
          do {
            let signInfo = try await signRepository.autoSign()
            observer.onNext(.setDestination(signInfo.loginSuccess ? .main : .login))
          } catch {
            observer.onNext(.setDestination(.login))
          }
        }
        return Disposables.create()
      }
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
