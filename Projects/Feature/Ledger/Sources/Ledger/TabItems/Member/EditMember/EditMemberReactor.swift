import NetworkService

import ReactorKit
import RxSwift
import RxCocoa

final class EditMemberReactor: Reactor {
  struct State {
    let agencyID: Int
    let member: Member
    
    @Pulse var destination: Destination?
    @Pulse var error: MoneyMongError?
    
    enum Destination {
      case dismiss
    }
  }
  
  enum Action {
    case tapKickOut
    case tapSaveButton(Member.Role)
  }
  
  enum Mutation {
    case setDestination(State.Destination)
    case setError(MoneyMongError)
  }
  
  let initialState: State
  
  private let agencyRepo: AgencyRepositoryInterface
  private let ledgerService: LedgerServiceInterface
  
  init(
    agencyID: Int,
    member: Member,
    agencyRepo: AgencyRepositoryInterface,
    ledgerService: LedgerServiceInterface
  ) {
    self.initialState = .init(agencyID: agencyID, member: member)
    self.agencyRepo = agencyRepo
    self.ledgerService = ledgerService
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .tapKickOut:
      return .just(.setDestination(.dismiss))
    case let .tapSaveButton(role):
      let (id, userID) = (currentState.agencyID, currentState.member.userID)
      return .task {
        try await agencyRepo.changeMemberRole(id: id, userId: userID, role: role.rawValue)
      }
      .do(onCompleted: { [weak self] in
        _ = self?.ledgerService.member.update()
      })
      .map { .setDestination(.dismiss) }
      .catch { return .just(.setError($0.toMMError)) }
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setDestination(value):
      newState.destination = value
    case let .setError(value):
      newState.error = value
    }
    return newState
  }
}
