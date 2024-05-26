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
    case setError(MoneyMongError)
    case setIsLoading(Bool)
    case setIsEdit(Bool)
    case setDeleteCompleted(Void)
    case setIsValid(Bool)
    case setIsChanged(Bool)
    case setUpdatedItem(LedgerDetail)
  }

  struct State {
    let ledgerId: Int
    var isChanged: Bool = false
    var updatedItem: LedgerDetail?
    @Pulse var role: Member.Role
    @Pulse var ledger: LedgerDetail?
    @Pulse var error: MoneyMongError?
    @Pulse var isLoading: Bool?
    @Pulse var isEdit: Bool = false
    @Pulse var isValid: Bool?
    @Pulse var deleteCompleted: Void?
  }

  var initialState: State
  private let formatter = ContentFormatter()
  private let ledgerRepository: LedgerRepositoryInterface
  private let ledgerService: LedgerServiceInterface
  private(set) var ledgerDetailService: LedgerDetailContentsServiceInterface

  init(
    ledgerID: Int,
    role: Member.Role,
    ledgerRepository: LedgerRepositoryInterface,
    ledgerService: LedgerServiceInterface,
    ledgerDetailService: LedgerDetailContentsServiceInterface
  ) {
    self.initialState = State(ledgerId: ledgerID, role: role)
    self.ledgerRepository = ledgerRepository
    self.ledgerService = ledgerService
    self.ledgerDetailService = ledgerDetailService
  }

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    return Observable.merge(mutation, serviceMutation)
  }

  private var serviceMutation: Observable<Mutation> {
    return ledgerDetailService.event
      .withUnretained(self)
      .flatMap { owner, mutation -> Observable<Mutation> in
        switch mutation {
        case .isValueChanged(let isChanged, let item):
          return .concat([
            .just(.setIsChanged(isChanged)),
            .just(.setUpdatedItem(item))
          ])
        case .isValidChanged(let value):
          return .just(.setIsValid(value))
        case .shouldDeleteImage(let imageItem):
          return .concat([
            .just(.setIsLoading(true)),

              .task {
                return try await self.ledgerRepository.receiptImageDelete(
                  detailId: self.currentState.ledgerId,
                  receiptId: imageItem.id
                )
              }
              .map { .setIsLoading(false) }
              .catch { .just(.setError($0.toMMError)) },

              .just(.setIsLoading(false))
          ])
        }
      }
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {

    case .onAppear:
      return .concat([
        .just(.setIsLoading(true)),

          .task { return try await ledgerRepository.fetchLedgerDetail(id: currentState.ledgerId) }
          .map { .setLedger($0) }
          .catch { return .just(.setError($0.toMMError))},

          .just(.setIsLoading(false))
      ])

    case .didTapDelete:
      return .concat([
        .just(.setIsLoading(true)),

          .task { return try await ledgerRepository.delete(id: currentState.ledgerId) }
          .map { [weak self] in self?.ledgerService.ledgerList.updateList() }
          .map { .setDeleteCompleted(()) }
          .catch { return .just(.setError($0.toMMError))},

          .just(.setIsLoading(false))
      ])

    case .didTapEdit:
      if let ledger = currentState.updatedItem, currentState.isEdit, currentState.isChanged {
        return .concat([
          .just(.setIsLoading(true)),

            .task { return try await ledgerRepository.update(ledger: ledger) }
            .map { [weak self] in self?.ledgerService.ledgerList.updateList() }
            .map { .setIsLoading(false) }
            .catch { return .just(.setError($0.toMMError))},

            .just(.setIsEdit(!(currentState.isEdit)))
        ])
      } else {
        return .just(.setIsEdit(!(currentState.isEdit)))
      }
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
    case .setIsValid(let value):
      newState.isValid = value
    case .setError(let error):
      newState.error = error
    case .setIsChanged(let isChanged):
      newState.isChanged = isChanged
    case .setUpdatedItem(let item):
      newState.updatedItem = item
    }
    return newState
  }
}
