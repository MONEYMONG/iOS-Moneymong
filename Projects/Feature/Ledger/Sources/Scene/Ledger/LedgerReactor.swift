import Foundation

import AgencyInterface
import BaseDomain
import UserInterface
import Utility

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
  
  private let service: LedgerServiceInterface
  
  private let getMyAgencyUseCase: GetMyAgencyUseCaseInterface
  private let getSelectedAgency: GetSelectedAgencyUseCaseInterface
  private let updateSelectedAgency: UpdateSelectedAgencyUseCaseInterface
  
  init(
    getMyAgencyUseCase: GetMyAgencyUseCaseInterface,
    getSelectedAgency: GetSelectedAgencyUseCaseInterface,
    updateSelectedAgency: UpdateSelectedAgencyUseCaseInterface,
    ledgerService: LedgerServiceInterface
  ) {
    self.getMyAgencyUseCase = getMyAgencyUseCase
    self.getSelectedAgency = getSelectedAgency
    self.updateSelectedAgency = updateSelectedAgency
    self.service = ledgerService
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .requestMyAgencies:
      return .task {
        try await getMyAgencyUseCase.execute()
      }
      .map { [weak self] agencies in
        let agencyID = self?.getSelectedAgency.execute()
        let agency = agencies.first(where: { $0.id == agencyID }) ?? agencies.first
        
        if let agency {
          self?.updateSelectedAgency.execute(id: agency.id)
          self?.service.agency.updateAgency(agency)
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
  
  public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let stream = service.agency.event
      .flatMap { event -> Observable<Mutation> in
        switch event {
        case let .update(agency):
          return .just(.setAgency(agency))
        }
      }
    
    return .merge(stream, mutation)
  }
}
