import NetworkService

import ReactorKit

final class LedgerDetailReactor: Reactor {
  
  enum Action {
    case onAppear
    case didTapDelete
    case didTapEdit
    case didValueChanged(Bool)
  }
  
  enum Mutation {
    case setLedger(LedgerDetail)
    case setIsLoading(Bool)
    case setIsEdit(Bool)
    case setDeleteCompleted(Void)
    case isChanged(Bool)
  }
  
  struct State {
    let ledgerId: Int
    @Pulse var role: Member.Role
    @Pulse var ledger: LedgerDetail?
    @Pulse var isLoading: Bool?
    @Pulse var isEdit: Bool = false
    @Pulse var isChanged: Bool?
    @Pulse var deleteCompleted: Void?
  }
  
  var initialState: State
  private let formatter = ContentFormatter()
  private let ledgerRepository: LedgerRepositoryInterface
  private(set) var ledgerService: LedgerServiceInterface

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

  func transform(action: Observable<Action>) -> Observable<Action> {
    return Observable.merge(action, serviceAction)
  }

  private var serviceAction: Observable<Action> {
    return ledgerService.ledgerContents.event
      .withUnretained(self)
      .flatMap { owner, action -> Observable<Action> in
        if case .isValueChanged(let value) = action {
          return .just(.didValueChanged(value))
        }
        return .just(.didValueChanged(false))
      }
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
      return .just(.setIsEdit(!(currentState.isEdit)))

    case .didValueChanged(let value):
      return .just(.isChanged(value))
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
    case .isChanged(let value):
      newState.isChanged = value
    }
    return newState
  }
}
