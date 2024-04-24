import ReactorKit
import NetworkService
import LocalStorage

final class LoginReactor: Reactor {

  enum Action {
    case kakao
    case apple
    case requestLogin(provider: String, accessToken: String)
    //    case moveToMainScene
    //    case moveToSignUpScene
  }

  enum Mutation {
    case setIsLoading(Bool)
    case setErrorMessage(String)
    case setSchoolInfoExist(Bool)
  }

  struct State {
    @Pulse var isLoading: Bool = false
    @Pulse var errorMessage: String?
    @Pulse var schoolInfoExist: Bool?
  }

  let initialState: State = State()
  private let kakaoAuthManager: KakaoAuthManager
  private let signRepository: SignRepositoryInterface

  init(
    kakaoAuthManager: KakaoAuthManager,
    signRepository: SignRepositoryInterface
  ) {
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

    case .apple:
      return Observable.create { observer in
        Disposables.create()
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
            KeychainHelper.shared.create(key: .accessToken, value: signInfo.accessToken)
            KeychainHelper.shared.create(key: .refreshToken, value: signInfo.refreshToken)
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
