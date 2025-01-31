import Foundation

import AgencyInterface
import BaseDomain
import UserInterface

import ReactorKit

final class SelectAgencySheetReactor: Reactor {
  struct State {
    let userID: Int
    @Pulse var agency = [Agency]()
    
    @Pulse var selectedAgencyID: Int
    
    @Pulse var isLoading = false
    @Pulse var error: MoneyMongError?
  }
  
  enum Action {
    case onAppear
    case tapCell(Agency)
  }
  
  enum Mutation {
    case setError(MoneyMongError)
    case setAgencies([Agency])
    case setSelectedAgencyID(Int)
    case setLoading(Bool)
  }
  
  init(
    getMyAgencyUseCase: GetMyAgencyUseCaseInterface,
    updateSelectedAgencyUseCase: UpdateSelectedAgencyUseCaseInterface,
    getUserIDUseCase: GetUserIDUseCaseInterface,
    getSelectedAgencyUseCase: GetSelectedAgencyUseCaseInterface,
    service: LedgerServiceInterface
  ) {
    self.getMyAgencyUseCase = getMyAgencyUseCase
    self.updateSelectedAgencyUseCase = updateSelectedAgencyUseCase
    self.service = service
    self.initialState = .init(
      userID: getUserIDUseCase.execute(),
      selectedAgencyID: getSelectedAgencyUseCase.execute()!
    )
  }
  
  let initialState: State
  private let service: LedgerServiceInterface
  
  private let getMyAgencyUseCase: GetMyAgencyUseCaseInterface
  private let updateSelectedAgencyUseCase: UpdateSelectedAgencyUseCaseInterface
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .onAppear:
      return .concat(
        .just(.setLoading(true)),
        
        .task { try await getMyAgencyUseCase.execute() }
        .map { .setAgencies($0) }
        .catch { return .just(.setError($0.toMMError)) },
        
        .just(.setLoading(false))
      )
    case let .tapCell(agency):
      updateSelectedAgencyUseCase.execute(id: agency.id)
      service.agency.updateAgency(agency)
      return .just(.setSelectedAgencyID(agency.id))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case let .setAgencies(value):
      newState.agency = value
    case let .setSelectedAgencyID(value):
      newState.selectedAgencyID = value
    case let .setError(value):
      newState.error = value
    case let .setLoading(value):
      newState.isLoading = value
    }
    
    return newState
  }
}
