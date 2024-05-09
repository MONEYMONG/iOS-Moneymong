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
    case setRecentLoginType(LoginType?)
  }

  enum Destination {
    case main
    case signUp
  }

  struct State {
    @Pulse var isLoading: Bool?
    @Pulse var errorMessage: String?
    @Pulse var destination: Destination?
    @Pulse var recentLoginType: LoginType?
  }

  let initialState: State = State()
  private let signRepository: SignRepositoryInterface

  init(signRepository: SignRepositoryInterface) {
    self.signRepository = signRepository
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {

    case .onAppear:
      return .just(.setRecentLoginType(signRepository.recentLoginType()))

    case .login(let loginType):
      return .task {
        switch loginType {
        case .kakao:
          let authInfo = try await self.signRepository.kakaoSign()
          return try await self.signRepository.sign(
            provider: loginType.value,
            accessToken: authInfo.accessToken,
            name: nil,
            code: nil
          )

        case .apple:
          let authInfo = try await self.signRepository.appleSign()
          return try await self.signRepository.sign(
            provider: loginType.value,
            accessToken: authInfo.idToken,
            name: authInfo.name,
            code: authInfo.authorizationCode
//            code: nil
          )
        }
      }
      .map { .setDestination($0.schoolInfoExist ? .main : .signUp) }
      .catch { .just(.setErrorMessage($0.localizedDescription)) }
    }
  }

  @discardableResult
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setIsLoading(let isLoading):
      newState.isLoading = isLoading
    case .setErrorMessage(let errorMessage):
      newState.errorMessage = errorMessage
    case .setDestination(let destination):
      newState.destination = destination
    case .setRecentLoginType(let recentLoginType):
      newState.recentLoginType = recentLoginType
    }
    return newState
  }
}
