import ReactorKit
import NetworkService
import LocalStorage

final class LoginReactor: Reactor {

  enum Action {
    case kakao
    case apple
  }

  enum Mutation {
    case setIsLoading(Bool)
    case setErrorMessage(String)
    case setIsSign(Bool)
    case setInfo(SignInfo)
  }

  struct State {
    @Pulse var isLoading: Bool = false
    @Pulse var errorMessage: String? = nil
    @Pulse var isSign: Bool = false
    @Pulse var info: SignInfo? = nil
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
        .flatMap { token -> Observable<Mutation> in
          Observable.concat([
            .just(.setIsLoading(true)),
            .task(type: SignInfo.self) {
              try await self.signRepository.sign(provider: "KAKAO", accessToken: token)
            }
              .compactMap { .setInfo($0) }
              .catch { error in
                  .just(.setErrorMessage(error.localizedDescription))
              }
            ,
            .just(.setIsLoading(false)),
          ])
        }

    case .apple:
      return Observable.just(.setIsSign(false))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setIsLoading(let isLoading):
      newState.isLoading = isLoading
    case .setErrorMessage(let errorMessage):
      newState.errorMessage = errorMessage
    case .setIsSign(let isSign):
      newState.isSign = isSign
    case .setInfo(let info):
      newState.info = info
    }
    return newState
  }
}
