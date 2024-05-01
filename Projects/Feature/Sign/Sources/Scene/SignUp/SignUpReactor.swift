import NetworkService
import LocalStorage

import ReactorKit

final class SignUpReactor: Reactor {

  enum Action {
    case searchKeyword(String)
    case selectUniversity(University)
    case unSelectUniversity
    case selectGrade(Int)
    case confirm
  }

  enum Mutation {
    case setSchoolList([University])
    case setIsLoading(Bool)
    case setErrorMessage(String)
    case setInputType(InputType)
    case setIsConfirm(Bool)
    case setDestination(Destination)
  }

  enum InputType {
    case university
    case grade(University)
  }

  enum Destination {
    case congratulations
  }

  struct State {
    @Pulse var isConfirm: Bool = false
    @Pulse var isLoading: Bool?
    @Pulse var errorMessage: String?
    @Pulse var schoolList: [University]?
    @Pulse var inputType: InputType = .university
    @Pulse var destination: Destination?
  }

  let initialState: State = State()
  private let universityRepository: UniversityRepositoryInterface

  var selectedUniversity: University?
  var selectedGrade: Int?

  init(
    universityRepository: UniversityRepositoryInterface
  ) {
    self.universityRepository = universityRepository
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .searchKeyword(let keyword):
      return Observable.just([
        University(id: 0, schoolName: "말랑대학교"),
        University(id: 1, schoolName: "두두대학교"),
        University(id: 2, schoolName: "사파리대학교")
      ])
      .map { .setSchoolList($0) }
//      return Observable.create { [unowned self] observer in
//        observer.onNext(.setIsLoading(true))
//        Task {
//          do {
//            let universityList = try await universityRepository.universities(keyword: keyword)
//            observer.onNext(.setSchoolList(universityList))
//          } catch {
//            observer.onNext(.setErrorMessage(error.localizedDescription))
//          }
//        }
//        observer.onNext(.setIsLoading(false))
//        return Disposables.create()
//      }

    case .selectUniversity(let university):
      selectedUniversity = university
      return .just(.setInputType(.grade(university)))

    case .unSelectUniversity:
      selectedUniversity = nil
      selectedGrade = nil
      return Observable.create { observer in
        observer.onNext(.setIsConfirm(false))
        observer.onNext(.setInputType(.university))
        return Disposables.create()
      }

    case .selectGrade(let grade):
      selectedGrade = grade
      if selectedUniversity != nil, selectedGrade != nil {
        return .just(.setIsConfirm(true))
      }
      return .just(.setIsConfirm(false))

    case .confirm:
      return Observable.create { [unowned self] observer in
        observer.onNext(.setIsLoading(true))
        Task {
          do {
            guard let selectedUniversity, let selectedGrade else {
              observer.onNext(.setErrorMessage("필수 입력값을 입력해 주세요."))
              return Disposables.create()
            }
//            try await universityRepository.university(
//              name: selectedUniversity.schoolName,
//              grade: selectedGrade
//            )
            observer.onNext(.setDestination(.congratulations))
          } catch {
            observer.onNext(.setErrorMessage(error.localizedDescription))
          }
          return Disposables.create()
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
    case .setSchoolList(let list):
      newState.schoolList = list
    case .setInputType(let type):
      newState.inputType = type
    case .setIsConfirm(let value):
      newState.isConfirm = value
    case .setDestination(let destination):
      newState.destination = destination
    }
    return newState
  }
}

public extension Observable {
  static func task<T>(@_implicitSelfCapture _ c: @escaping () async throws -> T) -> Observable<T> {
    return Single<T>.create { single in
      let task = Task {
        do {
          let result = try await c()
          single(.success(result))
        } catch {
          single(.failure(error))
        }
      }
      return Disposables.create {
        task.cancel()
      }
    }
    .asObservable()
  }
}
