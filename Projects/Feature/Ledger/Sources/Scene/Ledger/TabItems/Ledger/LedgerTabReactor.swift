import ReactorKit

import NetworkService

final class LedgerTabReactor: Reactor {

  enum Action {
    case didTapDateRangeView
  }

  enum Mutation {
    case setDateRange(start: DateInfo, end: DateInfo)
    case setDestination(State.Destination)
    case setAgencyID(Int)
    case setLoading(Bool)
    case requestLedgerList(LedgerList)
  }

  struct State {
    @Pulse var agencyID: Int = 0
    @Pulse var totalBalance: String = "0"
    @Pulse var filterType: FundType? = nil
    @Pulse var ledgers: [Ledger] = []
    @Pulse var dateRange: (start: DateInfo, end: DateInfo) = (
      DateInfo(year: 2023, month: 12),
      DateInfo(year: 2024, month: 5)
    )
    @Pulse var isLoading = false
    @Pulse var destination: Destination?
    
    enum Destination {
      case datePicker(start: DateInfo, end: DateInfo)
    }
  }
  
  let initialState: State = State()
  private let service: LedgerServiceInterface
  private let ledgerRepo: LedgerRepositoryInterface
  private let formatter = ContentFormatter()

  init(ledgerService: LedgerServiceInterface, ledgerRepo: LedgerRepositoryInterface) {
    self.service = ledgerService
    self.ledgerRepo = ledgerRepo
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .didTapDateRangeView:
        .just(.setDestination(
          .datePicker(
            start: currentState.dateRange.start,
            end: currentState.dateRange.end
          )
        ))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    newState.destination = nil
    switch mutation {
    case let .setDateRange(start, end):
      newState.dateRange = (start, end)
    case let .setDestination(destination):
      newState.destination = destination
    case let .requestLedgerList(ledgerList):
      let balance = formatter.amount(String(ledgerList.totalBalance)) ?? "0"
      newState.totalBalance = balance
      newState.ledgers = ledgerList.ledgers
    case let .setAgencyID(id):
      newState.agencyID = id
    case let .setLoading(value):
      newState.isLoading = value
    }
    return newState
  }
  
  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    return Observable.merge(mutation, serviceMutation)
  }
  
  private var serviceMutation: Observable<Mutation> {
    let ledgerListUpdate = service.ledgerList.event
      .withUnretained(self)
      .flatMap { owner, event -> Observable<Mutation> in
        switch event {
        case let .selectedDateRange(start, end):
          return .concat([
            .just(.setDateRange(start: start, end: end)),
            owner.requestLedgerList()
          ])
        case .createLedgerRecord:
          return owner.requestLedgerList()
        }
    }
    
    let agencyUpdate = service.agency.event
      .withUnretained(self)
      .flatMap { owner, event -> Observable<Mutation> in
      switch event {
      case let .update(agency):
        return .concat([
          .just(.setAgencyID(agency.id)),
          owner.requestLedgerList()
        ])
      }
    }
    return .merge(ledgerListUpdate, agencyUpdate)
  }
  
  private func requestLedgerList() -> Observable<Mutation> {
    return .concat([
      .just(.setLoading(true)),
      .task { [weak self] in
        guard let self else { throw MoneyMongError.unknown("알 수 없는 에러가 발생했습니다") }
        return try await self.ledgerRepo.fetchLedgerList(
          id: self.currentState.agencyID, // 소속 ID
          start: self.currentState.dateRange.start,
          end: self.currentState.dateRange.end,
          page: 0, // 0부터
          limit: 20, // 아이템 수
          fundType: self.currentState.filterType
        )
      }
        .map { .requestLedgerList($0) }
        .catch { _ in .empty() },
      .just(.setLoading(false))
    ])
  }
}
