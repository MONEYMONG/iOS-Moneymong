import Core
import CreateAgencyInterface

import ReactorKit

final class InputUniversityInfoReactor: Reactor {

  enum Action {
    case searchKeyword(String)
    case selectUniversity(University)
    case unSelectUniversity
    case selectGrade(Int)
    case confirm
    case notUnivercityInfo
  }

  enum Mutation {
    case setSchoolList([University])
    case setEmptyList(Bool)
    case setIsLoading(Bool)
    case setErrorMessage(String)
    case setInputType(InputType)
    case setIsConfirm(Bool)
    case setDestination(Destination)
    case setSelectedUniversity(University)
    case setSelectedGrade(Int)
  }

  enum InputType {
    case university
    case grade(University)
  }

  enum Destination {
    case congratulations
    case complete(Int)
  }

  struct State {
    @Pulse var isConfirm: Bool = false
    @Pulse var isLoading: Bool?
    @Pulse var errorMessage: String?
    @Pulse var schoolList: [University]?
    @Pulse var isEmptyList: Bool?
    @Pulse var inputType: InputType = .university
    @Pulse var destination: Destination?
    @Pulse var agencyName: String
    @Pulse var agencyType: AgencyType
    var selectedUniversity: University?
    var selectedGrade: Int?
  }

  let initialState: State
  
  private let universityRepository: UniversityRepositoryInterface
  private let agencyRepository: AgencyRepositoryInterface

  init(
    agencyName: String,
    agencyType: AgencyType,
    universityRepository: UniversityRepositoryInterface,
    agencyRepository: AgencyRepositoryInterface
  ) {
    self.universityRepository = universityRepository
    self.agencyRepository = agencyRepository
    self.initialState = State(agencyName: agencyName, agencyType: agencyType)
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .searchKeyword(let keyword):
      return Observable.create { [unowned self] observer in
        if keyword == "" {
          observer.onNext(.setSchoolList([]))
          observer.onNext(.setEmptyList(false))
          return Disposables.create()
        }

        observer.onNext(.setIsLoading(true))
        Task {
          do {
            let universityList = try await universityRepository.universities(keyword: keyword)
            observer.onNext(.setSchoolList(universityList))
            observer.onNext(.setEmptyList(universityList.isEmpty))
          } catch {
            observer.onNext(.setErrorMessage(error.localizedDescription))
          }
        }
        observer.onNext(.setIsLoading(false))
        return Disposables.create()
      }

    case .selectUniversity(let university):
      return Observable.concat([
        .just(.setSelectedUniversity(university)),
        .just(.setInputType(.grade(university)))
      ])

    case .unSelectUniversity:
      return Observable.concat([
        .just(.setIsConfirm(false)),
        .just(.setInputType(.university))
      ])

    case .selectGrade(let grade):
      return Observable.create { [unowned self] observer in
        observer.onNext(.setSelectedGrade(grade))
        
        if currentState.selectedUniversity != nil,
           let grade = currentState.selectedGrade,
           (1...5) ~= grade
        {
          observer.onNext(.setIsConfirm(true))
        } else {
          observer.onNext(.setIsConfirm(false))
        }
        return Disposables.create()
      }

    case .confirm:
      return Observable.concat([
        .just(.setIsLoading(true)),
        .task { [unowned self] in
          guard let university = currentState.selectedUniversity,
                let grade = currentState.selectedGrade else {
            throw MoneyMongError.appError(.default, errorMessage: "필수 입력값을 입력해주세요.")
          }
          try await universityRepository.university(
            name: university.schoolName,
            grade: grade
          )
          
          return try await agencyRepository.create(name: currentState.agencyName, type: currentState.agencyType.rawValue)
        }
          .map { .setDestination(.complete($0)) }
          .catch { error in .just(.setErrorMessage(error.localizedDescription)) },

          .just(.setIsLoading(false))
      ])

    case .notUnivercityInfo:
      return Observable.concat([
        .just(.setIsLoading(true)),
        .task { [unowned self] in
          return try await universityRepository.university(name: nil, grade: nil)
        }
          .map {.setDestination(.congratulations) }
          .catch { error in .just(.setErrorMessage(error.localizedDescription)) },

          .just(.setIsLoading(false))
      ])
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
    case .setEmptyList(let value):
      newState.isEmptyList = value
    case .setSelectedUniversity(let university):
      newState.selectedUniversity = university
    case .setSelectedGrade(let grade):
      newState.selectedGrade = grade
    }
    return newState
  }
}
