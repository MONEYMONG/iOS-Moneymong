import NetworkService

import ReactorKit

final class LedgerDetailReactor: Reactor {

  enum Action {
    case onAppear
    case didTapDelete
    case didTapEdit
  }

  enum Mutation {
    case setLedger(LedgerDetail)
    case setIsLoading(Bool)
    case setIsEdit(Bool)
    case setDeleteCompleted(Void)
  }

  struct State {
    let ledgerId: Int
    let role: Member.Role
    @Pulse var ledger: LedgerDetail?
    @Pulse var isLoading: Bool = false
    @Pulse var isEdit: Bool = false
    @Pulse var isChanged: Bool = false
    @Pulse var deleteCompleted: Void?
  }

  var initialState: State
  private let formatter = ContentFormatter()
  private let ledgerRepository: LedgerRepositoryInterface
  private let ledgerService: LedgerServiceInterface

  init(
    ledgerID: Int,
    role: Member.Role,
    ledgerRepository: LedgerRepositoryInterface,
    ledgerService: LedgerServiceInterface
  ) {
    self.initialState = State(ledgerId: ledgerID, role: role)
    self.ledgerRepository = ledgerRepository
    self.ledgerService = ledgerService
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .onAppear:
      return .concat([
        .just(.setIsLoading(true)),
        .task { return try await ledgerRepository.fetchLedgerDetail(id: currentState.ledgerId) }
          .map { .setLedger($0) },
        .just(.setIsLoading(false))
      ])

    case .didTapDelete:
      return .concat([
        .just(.setIsLoading(true)),
        .task { return try await ledgerRepository.delete(id: currentState.ledgerId) }
          .map { [weak self] in
            self?.ledgerService.ledgerList.updateList()
          }
          .map { .setDeleteCompleted(()) },
        .just(.setIsLoading(false))
      ])

    case .didTapEdit:
      return .just(.setIsEdit(!currentState.isEdit))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setLedger(let ledger):
      newState.ledger = ledger
    case .setIsLoading(let isLoading):
      newState.isLoading = isLoading
    case .setIsEdit(let isEdit):
      newState.isEdit = isEdit
    case .setDeleteCompleted(let event):
      newState.deleteCompleted = event
    }
    return newState
  }
}
