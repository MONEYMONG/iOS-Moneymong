import ReactorKit
import NetworkService
import LocalStorage

final class LoginReactor: Reactor {
  enum Action {
    case onAppear
    case login(LoginType)
  }

  enum Mutation {
    case setIsLoading(Bool)
    case setErrorMessage(String)
    case setDestination(Destination)
  }

  enum LoginType: String {
    case kakao
    case apple

    var value: String {
      switch self {
      case .kakao: "KAKAO"
      case .apple: "APPLE"
      }
    }
  }

  public enum Destination {
    case main
    case signUp
  }

  struct State {
    @Pulse var isLoading: Bool?
    @Pulse var errorMessage: String?
    @Pulse var destination: Destination?
    @Pulse var recentLoginType: LoginType?
  }

  let initialState: State
  private let signRepository: SignRepositoryInterface

  init(recentLoginType: LoginType?, signRepository: SignRepositoryInterface) {
    initialState = State(recentLoginType: recentLoginType)
    self.signRepository = signRepository
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .login(let loginType):
      return Observable.create { [unowned self] observer in
        Task {
          do {
            var accessToken = ""
            switch loginType {
            case .kakao:
              accessToken = try await self.signRepository.kakaoSign()
            case .apple:
              accessToken = try await self.signRepository.appleSign()
            }

            observer.onNext(.setIsLoading(true))

            let response = try await self.signRepository.sign(
              provider: loginType.value,
              accessToken: accessToken
            )
            let destination: Destination = response.schoolInfoExist ? .main : .signUp
            observer.onNext(.setDestination(destination))

          } catch {
            observer.onNext(.setErrorMessage(error.localizedDescription))
          }
        }
        observer.onNext(.setIsLoading(false))
        return Disposables.create()
      }

    case .onAppear:
      return Observable.create { [unowned self] observer in
//         initialState.recentLoginType
        return Disposables.create()
      }
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setIsLoading(let isLoading):
      newState.isLoading = isLoading
    case .setErrorMessage(let errorMessage):
      newState.errorMessage = errorMessage
    case .setDestination(let destination):
      newState.destination = destination
    }
    return newState
  }
}
