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
        requestMyAgenciesMutation(),
        .just(.setLoading(false))
      )
    case .invite(let code, let agencyID):
      return .concat(
        .just(.setLoading(true)),
        .task {
          try await confirmCertificateCodeUseCase.execute(code: code, agencyID: agencyID)
        }
        .flatMap { [weak self] agency -> Observable<Mutation> in
          guard let self else { return .empty() }
          guard let agency else { return requestMyAgenciesMutation() }
          applySelected(agency)
          return .just(.setAgency(agency))
        }
        .catch { [weak self] error in
          guard let self else { return .just(.setError(error.toMMError)) }
          return .concat(
            .just(.setError(error.toMMError)),
            self.requestMyAgenciesMutation()
          )
        },
        .just(.setLoading(false))
      )
    }
  }

  private func requestMyAgenciesMutation() -> Observable<Mutation> {
    return .task { try await getMyAgencyUseCase.execute() }
      .map { [weak self] agencies -> Agency? in
        let selectedID = self?.getSelectedAgencyUseCase.execute()
        return agencies.first(where: { $0.id == selectedID }) ?? agencies.first
      }
      .do(onNext: { [weak self] agency in
        guard let agency else { return }
        self?.applySelected(agency)
      })
      .map { .setAgency($0) }
      .catch { .just(.setError($0.toMMError)) }
  }

  private func applySelected(_ agency: Agency) {
    updateSelectedAgencyUseCase.execute(id: agency.id)
    service.agency.updateAgency(agency)
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
