import ReactorKit

import NetworkService

final class LedgerTabReactor: Reactor {

  enum Action {
    case didTapDateRangeView
    case selectedFilter(Int)
  }

  enum Mutation {
    case setDateRange(start: DateInfo, end: DateInfo)
    case setDestination(State.Destination)
    case setAgencyID(Int)
    case setLoading(Bool)
    case setFilterType(FundType?)
    case requestLedgerList(LedgerList)
    case setRole(Member.Role?)
  }

  struct State {
    let userID: Int
    @Pulse var agencyID: Int = 0
    @Pulse var role: Member.Role?
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
  
  let initialState: State
  private let service: LedgerServiceInterface
  private let ledgerRepo: LedgerRepositoryInterface
  private let userRepo: UserRepositoryInterface
  private let agencyRepo: AgencyRepositoryInterface
  private let formatter = ContentFormatter()

  init(
    ledgerService: LedgerServiceInterface,
    ledgerRepo: LedgerRepositoryInterface,
    userRepo: UserRepositoryInterface,
    agencyRepo: AgencyRepositoryInterface
  ) {
    self.service = ledgerService
    self.ledgerRepo = ledgerRepo
    self.userRepo = userRepo
    self.agencyRepo = agencyRepo
    self.initialState = State(userID: userRepo.fetchUserID())
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .didTapDateRangeView:
        return .just(.setDestination(
          .datePicker(
            start: currentState.dateRange.start,
            end: currentState.dateRange.end
          )
        ))
    case let .selectedFilter(index):
      var fundType: FundType? = nil
      switch index {
      case 1:
        fundType = .expense
      case 2:
        fundType = .income
      default:
        break
      }
      return .concat([
        .just(.setFilterType(fundType)),
        requestLedgerList()
      ])
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
      let balance = formatter.convertToAmount(with: String(ledgerList.totalBalance)) ?? "0"
      newState.totalBalance = balance
      newState.ledgers = ledgerList.ledgers
    case let .setAgencyID(id):
      newState.agencyID = id
    case let .setLoading(value):
      newState.isLoading = value
    case let .setFilterType(fundType):
      newState.filterType = fundType
    case let .setRole(role):
      newState.role = role
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
      .task {
        return try await ledgerRepo.fetchLedgerList(
          id: currentState.agencyID, // 소속 ID
          start: currentState.dateRange.start,
          end: currentState.dateRange.end,
          page: 0, // 0부터
          limit: 20, // 아이템 수
          fundType: currentState.filterType
        )
      }
        .map { .requestLedgerList($0) }
        .catch { _ in .empty() },
      .task {
        let members = try await agencyRepo.fetchMemberList(id: currentState.agencyID)
        return members.first(where: { $0.userID == currentState.userID })?.role
      }
        .map { .setRole($0) },
      .just(.setLoading(false))
    ])
  }
}
