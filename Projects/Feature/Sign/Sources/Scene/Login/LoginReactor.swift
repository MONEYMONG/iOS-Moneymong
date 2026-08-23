import AuthInterface
import AgencyInterface
import BaseDomain
import BaseFeature

import ReactorKit


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
  
  private let signUpUseCase: SignUpUseCaseInterface
  private let getRecentLoginInfoUseCase: GetRecentLoginInfoUseCaseInterface
  private let getMyAgencyUseCase: GetMyAgencyUseCaseInterface

  init(
    signUpUseCase: SignUpUseCaseInterface,
    getRecentLoginInfoUseCase: GetRecentLoginInfoUseCaseInterface,
    getMyAgencyUseCase: GetMyAgencyUseCaseInterface = DIContainer.shared.resolve(type: GetMyAgencyUseCaseInterface.self)
  ) {
    self.signUpUseCase = signUpUseCase
    self.getRecentLoginInfoUseCase = getRecentLoginInfoUseCase
    self.getMyAgencyUseCase = getMyAgencyUseCase
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {

    case .onAppear:
      let loginType = getRecentLoginInfoUseCase.execute()
      return .just(.setRecentLoginType(loginType))

    case .login(let loginType):
      return .task {
        _ = try await signUpUseCase.execute(loginType: loginType)
        if DeepLinkManager.query != nil { return true }
        return try await !getMyAgencyUseCase.execute().isEmpty
      }
      .map { .setDestination($0 ? .main : .signUp) }
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
