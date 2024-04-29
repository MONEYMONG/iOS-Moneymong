import ReactorKit
import NetworkService
import LocalStorage

enum LoginType {
  case Kakao
  case Apple

  var value: String {
    switch self {
    case .Kakao: "KAKAO"
    case .Apple: "APPLE"
    }
  }
}

final class LoginReactor: Reactor {

  enum Action {
    case login(LoginType)
  }

  enum Mutation {
    case setIsLoading(Bool)
    case setErrorMessage(String)
    case moveToMain(Void)
  }

  struct State {
    @Pulse var isLoading: Bool?
    @Pulse var errorMessage: String?
    @Pulse var moveToMain: Void?
  }

  let initialState: State = State()
  private let signRepository: SignRepositoryInterface
  private let universityRepository: UniversityRepository

  init(
    signRepository: SignRepositoryInterface,
    universityRepository: UniversityRepository
  ) {
    self.signRepository = signRepository
    self.universityRepository = universityRepository
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .login(let loginType):
      return Observable.create { [unowned self] observer in
        Task {
          do {
            var accessToken = ""
            switch loginType {
            case .Kakao:
              accessToken = try await self.signRepository.kakaoSign()
            case .Apple:
              accessToken = try await self.signRepository.appleSign()
            }

            observer.onNext(.setIsLoading(true))

            let response = try await self.signRepository.sign(
              provider: loginType.value,
              accessToken: accessToken
            )

            if !response.schoolInfoExist {
              try await universityRepository.university(name: "홍익 대학교", grade: 4)
            }
            observer.onNext(.moveToMain(()))

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
    case .moveToMain(let result):
      newState.moveToMain = result
    }
    return newState
  }
}
