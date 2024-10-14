import ReactorKit

import Core

final class LedgerTabReactor: Reactor {
  
  enum Action {
    case didTapDateRangeView
    case selectedFilter(Int)
    case didTapWriteButton
    case didTapScanButton
    case didPrefech(Int)
  }
  
  enum Mutation {
    case setDateRange(start: DateInfo, end: DateInfo)
    case setDestination(State.Destination)
    case setAgencyID(Int)
    case setLoading(Bool)
    case setFilterType(FundType?)
    case setLedgerList([Ledger])
    case setTotalBalance(Int)
    case setRole(Member.Role?)
    case setPage(Int)
    case setTotalLedgerCount(Int)
  }
  
  struct State {
    let userID: Int
    var page: Int = 0
    var totalLedgerCount: Int = 0
    @Pulse var agencyID: Int? = nil
    @Pulse var role: Member.Role?
    @Pulse var totalBalance: String = "0"
    @Pulse var filterType: FundType? = nil
    @Pulse var ledgers: [Ledger] = []
    @Pulse var dateRange: DateRange
    @Pulse var isLoading = false
    @Pulse var destination: Destination?
    
    enum Destination {
      case datePicker(start: DateInfo, end: DateInfo)
      case createManualLedger(Int)
      case createOCRLedger(Int)
    }
  }
  
  let initialState: State
  private let service: LedgerServiceInterface
  private let ledgerRepo: LedgerRepositoryInterface
  private let userRepo: UserRepositoryInterface
  private let agencyRepo: AgencyRepositoryInterface
  let formatter: ContentFormatter
  private let listLimit = 20
  
  init(
    ledgerService: LedgerServiceInterface,
    ledgerRepo: LedgerRepositoryInterface,
    userRepo: UserRepositoryInterface,
    agencyRepo: AgencyRepositoryInterface,
    formatter: ContentFormatter
  ) {
    self.service = ledgerService
    self.ledgerRepo = ledgerRepo
    self.userRepo = userRepo
    self.agencyRepo = agencyRepo
    self.formatter = formatter
    
    
    if let fetchDateRange = ledgerRepo.fetchDateRange() {
      self.initialState = State(
        userID: userRepo.fetchUserID(),
        dateRange: fetchDateRange
      )
      return
    }
    
    let currentDate = formatter.convertToDate(date: .now).split(separator: "/").map { Int($0)! }
    let endYear = currentDate[0]
    let endMonth = currentDate[1]
    let endDate = DateInfo(year: endYear, month: endMonth)
    let startYear = endMonth - 5 > 0 ? endYear : endYear - 1
    let startMonth = endMonth - 5 > 0 ? endMonth - 5 : endMonth + 7
    let startDate = DateInfo(year: startYear, month: startMonth)
    
    self.initialState = State(
      userID: userRepo.fetchUserID(),
      dateRange: DateRange(start: startDate, end: endDate)
    )
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
        .just(.setLoading(true)),
        requestLedgerListFirstPage(agencyID: currentState.agencyID),
        .just(.setLoading(false))
      ])
    case .didTapWriteButton:
      guard let agencyID = currentState.agencyID else { return .empty() }
      return .just(.setDestination(.createManualLedger(agencyID)))
    case .didTapScanButton:
      guard let agencyID = currentState.agencyID else { return .empty() }
      return .just(.setDestination(.createOCRLedger(agencyID)))
    case let .didPrefech(row):
      guard isPageable(row: row) else { return .empty() }
      return .concat([
        .just(.setLoading(true)),
        .just(.setPage(currentState.page + 1)),
        requestLedgerList(agencyID: currentState.agencyID),
        .just(.setLoading(false))
      ])
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    newState.destination = nil
    switch mutation {
    case let .setDateRange(start, end):
      let newDateRange = DateRange(start: start, end: end)
      ledgerRepo.saveDateRange(newDateRange)
      newState.dateRange = newDateRange
    case let .setDestination(destination):
      newState.destination = destination
    case let .setLedgerList(ledgerList):
      if state.page == 0 {
        newState.ledgers = []
      }
      let items = ledgerList.enumerated().map { i, item in
        var newItem = item
        newItem.order = state.totalLedgerCount - i - newState.ledgers.count
        return newItem
      }
      newState.ledgers += items
    case let .setTotalBalance(balance):
      newState.totalBalance = formatter.convertToAmount(with: balance) ?? "0"
    case let .setAgencyID(id):
      newState.agencyID = id
    case let .setLoading(value):
      newState.isLoading = value
    case let .setFilterType(fundType):
      newState.filterType = fundType
    case let .setRole(role):
      newState.role = role
    case let .setPage(page):
      newState.page = page
    case let .setTotalLedgerCount(count):
      newState.totalLedgerCount = count
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
            .just(.setLoading(true)),
            owner.requestLedgerListFirstPage(agencyID: owner.currentState.agencyID),
            .just(.setLoading(false))
          ])
        case .createLedgerRecord:
          return .concat([
            .just(.setLoading(true)),
            owner.requestLedgerListFirstPage(agencyID: owner.currentState.agencyID),
            .just(.setLoading(false))
          ])
        case .update:
          return .concat([
            .just(.setLoading(true)),
            owner.requestLedgerListFirstPage(agencyID: owner.currentState.agencyID),
            .just(.setLoading(false))
          ])
        }
      }
    
    let agencyUpdate = service.agency.event
      .withUnretained(self)
      .flatMap { owner, event -> Observable<Mutation> in
        switch event {
        case let .update(agency):
          guard let id = agency?.id else { return .empty() }
          return .concat([
            .just(.setAgencyID(id)),
            .just(.setLoading(true)),
            .merge([
              owner.requestLedgerListFirstPage(agencyID: id),
              owner.requestMembers(agencyID: id)
            ]),
            .just(.setLoading(false))
          ])
        }
      }
    return .merge(ledgerListUpdate, agencyUpdate)
  }
  
  private func requestLedgerList(agencyID: Int?) -> Observable<Mutation> {
    guard let agencyID else { return .empty() }
    return .task {
      return try await ledgerRepo.fetchLedgerList(
        id: agencyID, // 소속 ID
        start: currentState.dateRange.start,
        end: currentState.dateRange.end,
        page: currentState.page, // 0부터
        limit: listLimit, // 아이템 수
        fundType: currentState.filterType
      )
    }
    .withUnretained(self)
    .observe(on: MainScheduler.instance)
    .flatMap { owner, item -> Observable<Mutation> in
      return
        .concat([
          .just(.setTotalLedgerCount(item.totalCount)),
          .merge([
            .just(.setTotalBalance(item.totalBalance)),
            .just(.setLedgerList(item.ledgers))
          ])
        ])
    }
    .catch { _ in .empty() }
  }
  
  private func requestLedgerListFirstPage(agencyID: Int?) -> Observable<Mutation> {
    return .concat([
      .just(.setPage(0)),
      requestLedgerList(agencyID: agencyID)
    ])
  }
  
  private func requestMembers(agencyID: Int?) -> Observable<Mutation> {
    guard let agencyID else { return .empty() }
    return .task {
      let members = try await agencyRepo.fetchMemberList(id: agencyID)
      return members.first(where: { $0.userID == currentState.userID })?.role
    }
    .map { .setRole($0) }
    .catch { _ in .empty() }
  }
  
  private func isPageable(row: Int) -> Bool {
    let paginationRow: Int = Int(Double(currentState.page + 1) * Double(listLimit) * 0.8)
    return !currentState.isLoading &&
    paginationRow < row
  }
}
