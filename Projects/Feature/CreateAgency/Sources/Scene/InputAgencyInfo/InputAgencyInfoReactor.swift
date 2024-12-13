import Core
import CreateAgencyInterface

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
    }
  }
  
  public enum Action {
    case textFieldDidChange(String)
    case selectedIndexDidChange(Int)
    case tapCreateButton
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
  private let agencyRepo: AgencyRepositoryInterface
  private let universityRepo: UniversityRepositoryInterface
  
  init(
    universityType: UniversityType,
    agencyRepo: AgencyRepositoryInterface,
    universityRepo: UniversityRepositoryInterface
  ) {
    self.agencyRepo = agencyRepo
    self.initialState = State(universityType: universityType)
    self.universityRepo = universityRepo
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
              try await universityRepo.university(name: nil, grade: nil)
            }
            return try await agencyRepo.create(
              name: currentState.text,
              type: currentState.agencyType.rawValue
            )
          }
            .map { .setDestination(.complete($0)) }
            .catch { return .just(.setError($0.toMMError)) },
          .just(.setLoading(false))
        )
      }
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
    case 0: .inSchoolClub
    case 1: .studentCouncil
    case 2: .general
    default: nil
    }
  }
}
