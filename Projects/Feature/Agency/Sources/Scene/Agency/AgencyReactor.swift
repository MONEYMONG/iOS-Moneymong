import ReactorKit

import NetworkService

public final class AgencyReactor: Reactor {

  public enum Action {
    case requestAgencyList
  }

  public enum Mutation {
    case setAgencies([Agency])
  }

  public struct State {
    @Pulse var items: [AgencySectionModel] = []
  }

  public let initialState: State = State()
  private let agencyRepo: AgencyRepositoryInterface

  init(agencyRepo: AgencyRepositoryInterface) {
    self.agencyRepo = agencyRepo
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .requestAgencyList:
      return .task {
        return try await agencyRepo.fetchList()
      }
      .map { .setAgencies($0) }
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case let .setAgencies(items):
      newState.items = [.init(items: items)]
    }
    
    return newState
  }
}
