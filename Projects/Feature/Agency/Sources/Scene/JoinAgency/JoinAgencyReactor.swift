import ReactorKit

import NetworkService

final class JoinAgencyReactor: Reactor {
  struct State {
    let agencyID: Int
    let agencyName: String
    
    @Pulse var codes: [String] = ["","","","","",""]
    
    @Pulse var destination: Destination?
    @Pulse var errorMessage: String?
    @Pulse var snackBarMessage: String?
    
    enum Destination {
      case joinComplete
    }
  }
  
  enum Action {
    case textFieldDidChange(text: String, index: Int)
    case requestJoinAgency
    case tapRetryButton
  }
  
  enum Mutation {
    case setCode(code: String, index: Int)
    case joinAgencyResponse(Result<Bool, MoneyMongError>)
  }
  
  let initialState: State
  
  private let repo: AgencyRepositoryInterface
  
  init(id: Int, name: String, repo: AgencyRepositoryInterface) {
    self.initialState = .init(agencyID: id, agencyName: name)
    self.repo = repo
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .textFieldDidChange(text, index):
      if let code = text.last {
        return .just(.setCode(code: String(code), index: index))
      } else {
        return .just(.setCode(code: "", index: index))
      }
      
    case .requestJoinAgency:
      let code = currentState.codes.compactMap { $0 }.map { String($0) }.joined()
      return .task {
        try await repo.certificateCode(id: currentState.agencyID, code: code)
      }
      .map { .joinAgencyResponse(.success($0)) }
      .catch { return .just(.joinAgencyResponse(.failure($0.toMMError))) }
      
    case .tapRetryButton:
      return .concat(
        .just(.setCode(code: "", index: 0)),
        .just(.setCode(code: "", index: 1)),
        .just(.setCode(code: "", index: 2)),
        .just(.setCode(code: "", index: 3)),
        .just(.setCode(code: "", index: 4)),
        .just(.setCode(code: "", index: 5))
      )
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setCode(code, index):
      newState.codes[index] = code
    case let .joinAgencyResponse(.success(value)):
      switch value {
      case true:
        newState.destination = .joinComplete
      case false:
        newState.snackBarMessage = "잘못된 초대코드입니다"
      }
      
    case let .joinAgencyResponse(.failure(value)):
      newState.errorMessage = value.errorDescription
    }
    return newState
  }
}
