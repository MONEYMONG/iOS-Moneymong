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
  private let ledgerService: LedgerServiceInterface
  
  init(
    userRepo: UserRepositoryInterface,
    agencyRepo: AgencyRepositoryInterface,
    ledgerService: LedgerServiceInterface
  ) {
    self.userRepo = userRepo
    self.agencyRepo = agencyRepo
    self.ledgerService = ledgerService
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .requestMyAgencies:
      let agencyID = userRepo.fetchSelectedAgency()
      
      return .task {
        try await agencyRepo.fetchMyAgency()
      }
      .map { [weak self] agencies in
        let agency = agencies.first(where: { $0.id == agencyID }) ?? agencies.first
        
        if let agency {
          _ = self?.ledgerService.agency.updateAgency(agency)
        }
        
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
