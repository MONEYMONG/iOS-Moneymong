import ReactorKit

import AgencyInterface
import BaseDomain
import Utility
import LedgerFeatureInterface

final class JoinAgencyReactor: Reactor {
  struct State {
    @Pulse var codes: [String] = ["","","","","",""]
    
    @Pulse var destination: Destination?
    @Pulse var errorMessage: String?
    @Pulse var snackBarMessage: String?
    
    enum Destination {
      case ledger
    }
  }
  
  enum Action {
    case textFieldDidChange(text: String, index: Int)
    case requestJoinAgency
    case tapRetryButton
  }
  
  enum Mutation {
    case setCode(code: String, index: Int)
    case joinAgencyResponse(Result<Agency?, MoneyMongError>)
  }
  
  let initialState: State
  
  private let confirmCertificateCodeUseCase: ConfirmCertificateCodeUseCaseInterface
  private let ledgerService: LedgerServiceInterface?

  init(
    confirmCertificateCodeUseCase: ConfirmCertificateCodeUseCaseInterface,
    ledgerService: LedgerServiceInterface?
  ) {
    self.initialState = .init()
    self.confirmCertificateCodeUseCase = confirmCertificateCodeUseCase
    self.ledgerService = ledgerService
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
      let codes = currentState.codes
      return .task {
        return try await confirmCertificateCodeUseCase.execute(code: codes)
      }
      .map { agency in .joinAgencyResponse(.success(agency)) }
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
      if let agency = value {
        ledgerService?.agency.updateAgency(agency)
        newState.destination = .ledger
      } else {
        newState.snackBarMessage = "잘못된 초대코드입니다"
      }
      
    case let .joinAgencyResponse(.failure(value)):
      newState.errorMessage = value.errorDescription
    }
    return newState
  }
}
