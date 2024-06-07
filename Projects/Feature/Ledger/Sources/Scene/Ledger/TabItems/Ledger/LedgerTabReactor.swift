import ReactorKit

import NetworkService

final class LedgerTabReactor: Reactor {

  enum Action {
    case didTapDateRangeView
    case selectedFilter(Int)
    case didTapWriteButton
    case didTapScanButton
  }

  enum Mutation {
    case setDateRange(start: DateInfo, end: DateInfo)
    case setDestination(State.Destination)
    case setAgencyID(Int)
    case setLoading(Bool)
    case setFilterType(FundType?)
    case setLedgerInfo(LedgerList)
    case setRole(Member.Role?)
  }

  struct State {
    let userID: Int
    @Pulse var agencyID: Int? = nil
    @Pulse var role: Member.Role?
    @Pulse var totalBalance: String = "0"
    @Pulse var filterType: FundType? = nil
    @Pulse var ledgers: [Ledger] = []
    @Pulse var dateRange: (start: DateInfo, end: DateInfo)
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
    
    let currentDate = formatter.convertToDate(date: .now).split(separator: "/").map { Int($0)! }
    let endYear = currentDate[0]
    let endMonth = currentDate[1]
    let endDate = DateInfo(year: endYear, month: endMonth)
    let startYear = endMonth - 5 > 0 ? endYear : endYear - 1
    let startMonth = endMonth - 5 > 0 ? endMonth - 5 : endMonth + 7
    let startDate = DateInfo(year: startYear, month: startMonth)
    
    self.initialState = State(
      userID: userRepo.fetchUserID(),
      dateRange: (startDate, endDate)
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
        requestLedgerList(agencyID: currentState.agencyID),
        .just(.setLoading(false))
      ])
    case .didTapWriteButton:
      guard let agencyID = currentState.agencyID else { return .empty() }
      return .just(.setDestination(.createManualLedger(agencyID)))
    case .didTapScanButton:
      guard let agencyID = currentState.agencyID else { return .empty() }
      return .just(.setDestination(.createOCRLedger(agencyID)))
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
    case let .setLedgerInfo(ledgerList):
      let balance = formatter.convertToAmount(with: ledgerList.totalBalance) ?? "0"
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
            .just(.setLoading(true)),
            owner.requestLedgerList(agencyID: owner.currentState.agencyID),
            .just(.setLoading(false))
          ])
        case .createLedgerRecord:
          return .concat([
            .just(.setLoading(true)),
            owner.requestLedgerList(agencyID: owner.currentState.agencyID),
            .just(.setLoading(false))
          ])
        case .update:
          return .concat([
            .just(.setLoading(true)),
            owner.requestLedgerList(agencyID: owner.currentState.agencyID),
            .just(.setLoading(false))
          ])
        }
    }
    
    let agencyUpdate = service.agency.event
      .withUnretained(self)
      .flatMap { owner, event -> Observable<Mutation> in
      switch event {
      case let .update(agency):
        return .concat([
          .just(.setAgencyID(agency.id)),
          .just(.setLoading(true)),
          .merge([
            owner.requestLedgerList(agencyID: agency.id),
            owner.requestMembers(agencyID: agency.id)
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
        page: 0, // 0부터
        limit: 20, // 아이템 수
        fundType: currentState.filterType
      )
    }
      .map { .setLedgerInfo($0) }
      .catch { _ in .empty() }
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
}
