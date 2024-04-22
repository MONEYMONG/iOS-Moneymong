import ReactorKit
import NetworkService

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
    @Pulse var errorMessage: String?
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
        .flatMap { token -> Observable<SignInfo> in
          return .task(type: SignInfo.self) {
            try await self.signRepository.sign(provider: "KAKAO", accessToken: token)
          }
        }
        .map { .setInfo($0) }

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

extension Observable {
  static func task<T>(type: T.Type, _ c: @escaping () async throws -> T) -> Observable<T> {
    return Single<T>.create { single in
      Task {
        do {
          let v = try await c()
          single(.success(v))
        } catch {
          single(.failure(error))
        }
      }
      return Disposables.create()
    }
    .asObservable()
  }
}
