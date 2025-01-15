import Core
import CreateAgencyInterface
import UserInterface
import AgencyInterface

import ReactorKit

final class InputUniversityInfoReactor: Reactor {

  enum Action {
    case searchKeyword(String)
    case selectUniversity(University)
    case confirm
    case notRegisterButtonDidTap
  }

  enum Mutation {
    case setSchoolList([University])
    case setEmptyList(Bool)
    case setIsLoading(Bool)
    case setErrorMessage(String)
    case setIsConfirm(Bool)
    case setDestination(State.Destination)
    case setSelectedUniversity(University?)
  }

  struct State {
    @Pulse var isConfirm: Bool = false
    @Pulse var isLoading: Bool?
    @Pulse var errorMessage: String?
    @Pulse var schoolList: [University]?
    @Pulse var isEmptyList: Bool?
    @Pulse var destination: State.Destination?
    @Pulse var agencyName: String
    @Pulse var agencyType: AgencyType
    @Pulse var selectedUniversity: University?
    
    enum Destination {
      case main
      case complete(Int)
    }
  }

  let initialState: State
  
  private let registerUniversitiesUseCase: RegisterUniversitiesUseCaseInterface
  private let searchUniversitiesUseCase: SearchUniversitiesUseCaseInterface
  private let createAgencyUseCase: CreateAgencyUseCaseInterface

  init(
    agencyName: String,
    agencyType: AgencyType,
    registerUniversitiesUseCase: RegisterUniversitiesUseCaseInterface,
    searchUniversitiesUseCase: SearchUniversitiesUseCaseInterface,
    createAgencyUseCase: CreateAgencyUseCaseInterface
  ) {
    self.registerUniversitiesUseCase = registerUniversitiesUseCase
    self.searchUniversitiesUseCase = searchUniversitiesUseCase
    self.createAgencyUseCase = createAgencyUseCase
    self.initialState = State(agencyName: agencyName, agencyType: agencyType)
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .searchKeyword(let keyword):
      return Observable.create { [unowned self] observer in
        observer.onNext(.setSelectedUniversity(nil))
        observer.onNext(.setIsConfirm(false))
        
        if keyword == "" {
          observer.onNext(.setSchoolList([]))
          observer.onNext(.setEmptyList(false))
          return Disposables.create()
        }

        observer.onNext(.setIsLoading(true))
        Task {
          do {
            let universityList = try await searchUniversitiesUseCase.execute(query: keyword)
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
      return .concat([
        .just(.setSelectedUniversity(university)),
        .just(.setIsConfirm(true))
      ])

    case .confirm:
      return Observable.concat([
        .just(.setIsLoading(true)),
        .task { [unowned self] in
          guard let university = currentState.selectedUniversity else {
            throw MoneyMongError.appError(.default, errorMessage: "필수 입력값을 입력해주세요.")
          }
          try await registerUniversitiesUseCase.execute(name: university.schoolName, grade: nil)
          return try await createAgencyUseCase.execute(name: currentState.agencyName, type: currentState.agencyType.rawValue)
        }
          .map { .setDestination(.complete($0)) }
          .catch { error in .just(.setErrorMessage(error.localizedDescription)) },
          .just(.setIsLoading(false))
      ])

    case .notRegisterButtonDidTap:
      return Observable.concat([
        .just(.setIsLoading(true)),
        .task { [unowned self] in
          try await registerUniversitiesUseCase.execute(name: nil, grade: nil)
        }
          .map {.setDestination(.main) }
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
    case .setIsConfirm(let value):
      newState.isConfirm = value
    case .setDestination(let destination):
      newState.destination = destination
    case .setEmptyList(let value):
      newState.isEmptyList = value
    case .setSelectedUniversity(let university):
      newState.selectedUniversity = university
    }
    return newState
  }
}
