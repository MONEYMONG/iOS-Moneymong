import ReactorKit
import NetworkService
import LocalStorage

final class LoginReactor: Reactor {

  enum Action {
    case kakao
    case apple
    case requestLogin(provider: String, accessToken: String)
  }

  enum Mutation {
    case setIsLoading(Bool)
    case setErrorMessage(String)
    case setSchoolInfoExist(Bool)
  }

  struct State {
    @Pulse var isLoading: Bool = false
    @Pulse var errorMessage: String = ""
    @Pulse var schoolInfoExist: Bool = false
  }

  let initialState: State = State()
  private let appleAuthManager: AppleAuthManager
  private let kakaoAuthManager: KakaoAuthManager
  private let localStorage: LocalStorageInterface
  private let signRepository: SignRepositoryInterface

  init(
    appleAuthManager: AppleAuthManager,
    kakaoAuthManager: KakaoAuthManager,
    localStorage: LocalStorageInterface,
    signRepository: SignRepositoryInterface
  ) {
    self.localStorage = localStorage
    self.appleAuthManager = appleAuthManager
    self.kakaoAuthManager = kakaoAuthManager
    self.signRepository = signRepository
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .kakao:
      return kakaoAuthManager.sign()
        .flatMap { [unowned self] accessToken in
          self.mutate(action: .requestLogin(provider: "KAKAO", accessToken: accessToken))
        }
        .catch { error in
            .just(.setErrorMessage(error.localizedDescription))
        }

    case .apple:
      return appleAuthManager.sign()
        .flatMap { [unowned self] accessToken in
          self.mutate(action: .requestLogin(provider: "APPLE", accessToken: accessToken))
        }

    case let .requestLogin(provider, accessToken):
      return Observable.create { [unowned self] observer in
        observer.onNext(.setIsLoading(true))
        Task {
          do {
            let signInfo = try await self.signRepository.sign(
              provider: provider,
              accessToken: accessToken
            )
            self.localStorage.create(to: .accessToken, value: signInfo.accessToken)
            self.localStorage.create(to: .refreshToken, value: signInfo.accessToken)
            observer.onNext(.setSchoolInfoExist(signInfo.schoolInfoExist))
          } catch {
            observer.onNext(.setErrorMessage(error.localizedDescription))
          }
        }
        observer.onNext(.setIsLoading(false))
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
    case .setSchoolInfoExist(let schoolInfoExist):
      newState.schoolInfoExist = schoolInfoExist
    }
    return newState
  }
}
