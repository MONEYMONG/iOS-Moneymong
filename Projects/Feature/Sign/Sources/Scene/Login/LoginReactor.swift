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
  private let userRepo: UserRepositoryInterface

  init(signRepository: SignRepositoryInterface, userRepo: UserRepositoryInterface) {
    self.signRepository = signRepository
    self.userRepo = userRepo
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {

    case .onAppear:
      return .just(.setRecentLoginType(signRepository.recentLoginType()))

    case .login(let loginType):
      return .task {
        let result: SignInfo
        
        switch loginType {
        case .kakao:
          let authInfo = try await signRepository.kakaoSign()
          result = try await signRepository.sign(
            provider: loginType.value,
            accessToken: authInfo.accessToken,
            name: nil,
            code: nil
          )

        case .apple:
          let authInfo = try await signRepository.appleSign()
          result = try await signRepository.sign(
            provider: loginType.value,
            accessToken: authInfo.idToken,
            name: authInfo.name,
            code: authInfo.authorizationCode
          )
        }
        
        _ = try await userRepo.user()
        
        return result
      }
      .map { .setDestination($0.schoolInfoExist ? .main : .signUp) }
      .catch { .just(.setErrorMessage($0.localizedDescription)) }
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
    case .setRecentLoginType(let recentLoginType):
      newState.recentLoginType = recentLoginType
    }
    return newState
  }
}
