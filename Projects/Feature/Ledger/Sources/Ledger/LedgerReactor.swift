import NetworkService

import ReactorKit

public final class LedgerReactor: Reactor {
  
  public enum Action {
    case requestMyAgencies
  }
  
  public enum Mutation {
    case setAgency(Agency?)
    case setError(MoneyMongError)
  }
  
  public struct State {
    @Pulse var agency: Agency?
    @Pulse var error: MoneyMongError?
  }
  
  public let initialState = State()
  private let agencyRepo: AgencyRepositoryInterface
  private let userRepo: UserRepositoryInterface
  
  init(userRepo: UserRepositoryInterface, agencyRepo: AgencyRepositoryInterface) {
    self.userRepo = userRepo
    self.agencyRepo = agencyRepo
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .requestMyAgencies:
      let agencyID = userRepo.fetchSelectedAgency()
      
      return .task {
        try await agencyRepo.fetchMyAgency()
      }
      .map { agencies in
        let agency = agencies.first(where: { $0.id == agencyID }) ?? agencies.first
        return .setAgency(agency)
      }
      .catch {
        return .just(.setError($0.toMMError))
      }
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setAgency(agency):
      newState.agency = agency
    case let .setError(error):
      newState.error = error
    }
    
    return newState
  }
}
