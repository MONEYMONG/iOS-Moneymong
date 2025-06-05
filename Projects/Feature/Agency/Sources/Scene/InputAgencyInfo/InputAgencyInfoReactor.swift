import Foundation

import AgencyFeatureInterface
import AgencyInterface
import AuthInterface
import BaseDomain
import BaseFeature
import UserInterface
import Utility
import LedgerFeatureInterface

import ReactorKit

public final class InputAgencyInfoReactor: Reactor {
  
  public struct State {
    @Pulse var text = "" // 소속 이름
    @Pulse var isButtonEnabled = false
    @Pulse var isLoading = false
    @Pulse var error: MoneyMongError?
    @Pulse var destination: Destination?
    
    public enum Destination {
      case main
      case dismiss
    }
  }
  
  public enum Action {
    case textFieldDidChange(String)
    case tapCreateButton
    case dismiss
  }
  
  public enum Mutation {
    case setText(String)
    case setError(MoneyMongError)
    case setLoading(Bool)
    case setButtonEnabled(Bool)
    case setDestination(State.Destination)
  }
  
  public let initialState: State
  private let createAgencyUseCase: CreateAgencyUseCaseInterface
  private let deleteUserUseCase: DeleteUserUseCaseInterface
  private let updateSelectedAgencyUseCase: UpdateSelectedAgencyUseCaseInterface
  private let ledgerService: LedgerServiceInterface?
  
  init(
    createAgencyUseCase: CreateAgencyUseCaseInterface,
    deleteUserUseCase: DeleteUserUseCaseInterface,
    updateSelectedAgencyUseCase: UpdateSelectedAgencyUseCaseInterface = DIContainer.shared.resolve(type: UpdateSelectedAgencyUseCaseInterface.self),
    ledgerService: LedgerServiceInterface?
  ) {
    self.initialState = State()
    self.createAgencyUseCase = createAgencyUseCase
    self.deleteUserUseCase = deleteUserUseCase
    self.updateSelectedAgencyUseCase = updateSelectedAgencyUseCase
    self.ledgerService = ledgerService
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .textFieldDidChange(text):
      return .concat(
        .just(.setText(text)),
        .just(.setButtonEnabled((1...20) ~= text.count))
      )
    case .tapCreateButton:
      return .concat(
        .just(.setLoading(true)),
        .task {
          let agenctID = try await createAgencyUseCase.execute(name: currentState.text)
          ledgerService?.agency.updateAgency(Agency(id: agenctID, name: currentState.text, count: 1))
          updateSelectedAgencyUseCase.execute(id: agenctID)
        }
          .map { .setDestination(.main) }
          .catch { return .just(.setError($0.toMMError)) },
        .just(.setLoading(false))
      )
    case .dismiss:
      return .just(.setDestination(.main))
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case let .setText(text):
      newState.text = text
    case let .setButtonEnabled(value):
      newState.isButtonEnabled = value
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

extension InputAgencyInfoReactor {
  func parsingAgencyType(with selectedIndex: Int) -> AgencyType? {
    switch selectedIndex {
    case 0: .general
    case 1: .inSchoolClub
    case 2: .studentCouncil
    default: nil
    }
  }
}
