import Foundation

import LedgerFeatureInterface
import AgencyInterface
import BaseDomain
import BaseFeature
import UserInterface
import Utility

import ReactorKit

public final class LedgerReactor: Reactor {
  
  public enum Action {
    case requestMyAgencies
    case invite(code: String, agencyID: Int)
  }
  
  public enum Mutation {
    case setAgency(Agency?)
    case setError(MoneyMongError)
    case setLoading(Bool)
  }
  
  public struct State {
    @Pulse var agency: Agency?
    @Pulse var error: MoneyMongError?
    @Pulse var isLoading: Bool = false
  }
  
  public let initialState = State()
  
  private let service: LedgerServiceInterface
  
  private let getMyAgencyUseCase: GetMyAgencyUseCaseInterface
  private let getSelectedAgencyUseCase: GetSelectedAgencyUseCaseInterface
  private let updateSelectedAgencyUseCase: UpdateSelectedAgencyUseCaseInterface
  private let confirmCertificateCodeUseCase: ConfirmCertificateCodeUseCaseInterface
  
  init(
    getMyAgencyUseCase: GetMyAgencyUseCaseInterface,
    getSelectedAgencyUseCase: GetSelectedAgencyUseCaseInterface,
    updateSelectedAgencyUseCase: UpdateSelectedAgencyUseCaseInterface,
    confirmCertificateCodeUseCase: ConfirmCertificateCodeUseCaseInterface = DIContainer.shared.resolve(type: ConfirmCertificateCodeUseCaseInterface.self),
    ledgerService: LedgerServiceInterface
  ) {
    self.getMyAgencyUseCase = getMyAgencyUseCase
    self.getSelectedAgencyUseCase = getSelectedAgencyUseCase
    self.updateSelectedAgencyUseCase = updateSelectedAgencyUseCase
    self.confirmCertificateCodeUseCase = confirmCertificateCodeUseCase
    self.service = ledgerService
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .requestMyAgencies:
      return .concat(
          .just(.setLoading(true)),
          .task {
            try await getMyAgencyUseCase.execute()
          }
          .map { [weak self] agencies in
            let agencyID = self?.getSelectedAgencyUseCase.execute()
            let agency = agencies.first(where: { $0.id == agencyID }) ?? agencies.first
            
            if let agency {
              self?.updateSelectedAgencyUseCase.execute(id: agency.id)
              self?.service.agency.updateAgency(agency)
            }

            return .setAgency(agency)
          }
          .catch { return .just(.setError($0.toMMError)) },
          .just(.setLoading(false))
        )
    case .invite(let code, let agencyID):
      return .concat(
          .just(.setLoading(true)),
          .task {
            try await confirmCertificateCodeUseCase.execute(code: code, agencyID: agencyID)
          }
          .map { [weak self] agency in
            self?.service.agency.updateAgency(agency)
            return .setAgency(agency)
          }.catch { return .just(.setError($0.toMMError)) },
          .just(.setLoading(false))
        )
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setAgency(agency):
      newState.agency = agency
    case let .setError(error):
      newState.error = error
    case .setLoading(let isLoading):
      newState.isLoading = isLoading
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
