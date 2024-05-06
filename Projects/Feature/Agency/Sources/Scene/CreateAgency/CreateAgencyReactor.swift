import NetworkService

import ReactorKit

final class CreateAgencyReactor: Reactor {
  
  struct State {
    @Pulse var index = 0 // 소속 종류: 동아리 or 학생회
    @Pulse var text = "" // 소속 이름
    @Pulse var isButtonEnabled = false
    @Pulse var error: MoneyMongError?
    
    @Pulse var destination: Destination?
    
    enum Destination {
      case complete
    }
  }
  
  enum Action {
    case textFieldDidChange(String)
    case selectedIndexDidChange(Int)
    case tapCreateButton
  }
  
  enum Mutation {
    case setText(String)
    case setError(MoneyMongError)
    case setSelectedIndex(Int)
    case setButtonEnabled(Bool)
    case setDestination(State.Destination)
  }
  
  public let initialState: State = State()
  private let agencyRepo: AgencyRepositoryInterface
  
  init(agencyRepo: AgencyRepositoryInterface) {
    self.agencyRepo = agencyRepo
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .textFieldDidChange(text):
      return .concat(
        .just(.setText(text)),
        .just(.setButtonEnabled((1...20) ~= text.count))
      )
      
    case let .selectedIndexDidChange(index):
      return .just(.setSelectedIndex(index))
      
    case .tapCreateButton:
      return .task {
        return try await agencyRepo.create(
          name: currentState.text,
          type: currentState.index == 0 ? "STUDENT_COUNCIL" : "IN_SCHOOL_CLUB"
        )
      }
      .map { _ in .setDestination(.complete) }
      .catch {
        return .just(.setError($0.toMMError))
      }
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
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
    }
    
    return newState
  }
}
