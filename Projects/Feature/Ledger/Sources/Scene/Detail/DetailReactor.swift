import NetworkService

import ReactorKit

final class DetailReactor: Reactor {

  enum Action {
    case onAppear
    case didTapDelete
    case didTapEdit
  }

  enum Mutation {
    case setLedger(LedgerDetailItem)
    case setIsLoading(Bool)
    case setIsEdit(Bool)
    case setDeleteCompleted(Void)
  }

  struct State {
    let ledgerId: Int
    let role: Member.Role
    @Pulse var ledger: LedgerDetailItem?
    @Pulse var isLoading: Bool = false
    @Pulse var isEdit: Bool = false
    @Pulse var isChanged: Bool = false
    @Pulse var deleteCompleted: Void?
  }

  var initialState: State
  private let formatter = ContentFormatter()
  private let ledgerRepository: LedgerRepositoryInterface

  init(
    ledgerID: Int,
    role: Member.Role,
    ledgerRepository: LedgerRepositoryInterface
  ) {
    self.initialState = State(ledgerId: ledgerID, role: role)
    self.ledgerRepository = ledgerRepository
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .onAppear:
      return .concat([
        .just(.setIsLoading(true)),
        .task { return try await ledgerRepository.fetchLedgerDetail(id: currentState.ledgerId) }
          .map {
            let (date, time) = self.formatter.convertToDateTime(with: $0.paymentDate)
            return LedgerDetailItem.init(
              id: $0.id,
              storeInfo: $0.storeInfo,
              amountText: self.formatter.convertToAmount(with: $0.amount) ?? "0",
              fundType: $0.fundType,
              memo: $0.description,
              paymentDate: date,
              paymentTime: time,
              receiptImageUrls: $0.receiptImageUrls,
              documentImageUrls: $0.documentImageUrls,
              authorName: $0.authorName
            )
          }
          .map { .setLedger($0) },
        .just(.setIsLoading(false))
      ])

    case .didTapDelete:
      return .concat([
        .just(.setIsLoading(true)),
        .task { return try await ledgerRepository.delete(id: currentState.ledgerId) }
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
