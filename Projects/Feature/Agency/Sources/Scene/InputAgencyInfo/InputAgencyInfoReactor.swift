import AgencyFeatureInterface
import AgencyInterface
import BaseDomain
import UserInterface
import Utility

import ReactorKit

public final class InputAgencyInfoReactor: Reactor {
  
  public struct State {
    @Pulse var agencyType: AgencyType = .inSchoolClub // 소속 종류: 동아리 or 학생회
    @Pulse var text = "" // 소속 이름
    @Pulse var isButtonEnabled = false
    
    @Pulse var isLoading = false
    @Pulse var error: MoneyMongError?
    
    @Pulse var universityType: UniversityType
    
    @Pulse var destination: Destination?
    
    public enum Destination {
      case complete(Int)
      case inputUniversity(String, AgencyType)
      case main
    }
  }
  
  public enum Action {
    case textFieldDidChange(String)
    case selectedIndexDidChange(Int)
    case tapCreateButton
    case notRegisterButtonDidTap
  }
  
  public enum Mutation {
    case setText(String)
    case setError(MoneyMongError)
    case setLoading(Bool)
    case setAgencyType(Int)
    case setButtonEnabled(Bool)
    case setDestination(State.Destination)
  }
  
  public let initialState: State
  private let createAgencyUseCase: CreateAgencyUseCaseInterface
  private let registerUniversitiesUseCase: RegisterUniversitiesUseCaseInterface
  
  init(
    universityType: UniversityType,
    createAgencyUseCase: CreateAgencyUseCaseInterface,
    registerUniversitiesUseCase: RegisterUniversitiesUseCaseInterface
  ) {
    self.initialState = State(universityType: universityType)
    self.createAgencyUseCase = createAgencyUseCase
    self.registerUniversitiesUseCase = registerUniversitiesUseCase
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .textFieldDidChange(text):
      return .concat(
        .just(.setText(text)),
        .just(.setButtonEnabled((1...20) ~= text.count))
      )
      
    case let .selectedIndexDidChange(index):
      return .just(.setAgencyType(index))
      
    case .tapCreateButton:
      if currentState.universityType == .unknown, currentState.agencyType != .general {
        return .just(.setDestination(.inputUniversity(currentState.text, currentState.agencyType)))
      } else {
        return .concat(
          .just(.setLoading(true)),
          .task {
            if currentState.universityType == .unknown {
              try await registerUniversitiesUseCase.execute(name: nil, grade: nil)
            }
            return try await createAgencyUseCase.execute(
              name: currentState.text,
              type: currentState.agencyType.rawValue
            )
          }
            .map { .setDestination(.complete($0)) }
            .catch { return .just(.setError($0.toMMError)) },
          .just(.setLoading(false))
        )
      }
      
    case .notRegisterButtonDidTap:
      return .task {
        if currentState.universityType == .unknown {
          try await registerUniversitiesUseCase.execute(name: nil, grade: nil)
        }
      }
      .map { .setDestination(.main) }
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case let .setText(text):
      newState.text = text
    case let .setButtonEnabled(value):
      newState.isButtonEnabled = value
    case let .setAgencyType(index):
      newState.agencyType = parsingAgencyType(with: index) ?? .inSchoolClub
    case let .setDestination(value):
      newState.destination = value
    case let .setError(value):
      newState.error = value
    case let .setLoading(value):
      newState.isLoading = value
    }
    
    return newState
  }
}

extension InputAgencyInfoReactor {
  func parsingAgencyType(with selectedIndex: Int) -> AgencyType? {
    switch selectedIndex {
    case 0: .general
    case 1: .inSchoolClub
    case 2: .studentCouncil
    default: nil
    }
  }
}
