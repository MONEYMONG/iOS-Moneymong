import Core
import CreateAgencyInterface

import ReactorKit

public final class InputAgencyInfoReactor: Reactor {
  
  public struct State {
    @Pulse var index = 0 // 소속 종류: 동아리 or 학생회
    @Pulse var text = "" // 소속 이름
    @Pulse var isButtonEnabled = false
    
    @Pulse var isLoading = false
    @Pulse var error: MoneyMongError?
    
    @Pulse var universityType: UniversityType
    
    @Pulse var destination: Destination?
    
    public enum Destination {
      case complete(Int)
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
    case setSelectedIndex(Int)
    case setButtonEnabled(Bool)
    case setDestination(State.Destination)
  }
  
  public let initialState: State
  private let agencyRepo: AgencyRepositoryInterface
  
  init(
    universityType: UniversityType,
    agencyRepo: AgencyRepositoryInterface
  ) {
    self.agencyRepo = agencyRepo
    self.initialState = State(universityType: universityType)
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
      
    case let .textFieldDidChange(text):
      return .concat(
        .just(.setText(text)),
        .just(.setButtonEnabled((1...20) ~= text.count))
      )
      
    case let .selectedIndexDidChange(index):
      return .just(.setSelectedIndex(index))
      
    case .tapCreateButton:
      return .concat(
        .just(.setLoading(true)),
        .task {
          let type: String
          
          switch currentState.index {
          case 0:
            type = "IN_SCHOOL_CLUB"
          case 1:
            type = "STUDENT_COUNCIL"
          case 2:
            type = "GENERAL"
          default:
            fatalError("Invalid type")
          }
          
          return try await agencyRepo.create(
            name: currentState.text,
            type: type
          )
        }
        .map { .setDestination(.complete($0)) }
        .catch { return .just(.setError($0.toMMError)) },
        
        .just(.setLoading(false))
      )
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case let .setText(text):
      newState.text = text
    case let .setButtonEnabled(value):
      newState.isButtonEnabled = value
    case let .setSelectedIndex(index):
      newState.index = index
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
