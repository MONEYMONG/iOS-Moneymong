import ReactorKit

import NetworkService

final class MemberTabReactor: Reactor {
  
  struct State {
    @Pulse var agency: Agency?
    @Pulse var userID: Int?
    @Pulse var name: String?
    @Pulse var role: Member.Role?
    @Pulse var invitationCode: String?
    
    @Pulse var members: [Member] = []
    @Pulse var error: MoneyMongError?
  }
  
  enum Action {
    case onappear
    case reissueInvitationCode // 초대코드 재발급
  }
  
  enum Mutation {
    case setUser(id: Int, name: String)
    case setAgency(Agency)
    case setMembers([Member])
    case setRole(Member.Role)
    case setInvitationCode(String)
    case setError(MoneyMongError)
  }
  
  let initialState: State = State()
  
  private let userRepo: UserRepositoryInterface
  private let agencyRepo: AgencyRepositoryInterface
  private let globalService: LedgerGlobalServiceInterface
  
  init(
    userRepo: UserRepositoryInterface,
    agencyRepo: AgencyRepositoryInterface,
    globalService: LedgerGlobalServiceInterface
  ) {
    self.userRepo = userRepo
    self.agencyRepo = agencyRepo
    self.globalService = globalService
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .onappear:
      return .concat(
        .merge(
          requestMyProfile(),
          requestInvitationCode()
        ),
        requestMembers()
      )
      
    case .reissueInvitationCode:
      guard let agency = currentState.agency else {
        fatalError("소속이 없을 수 없음")
      }
      
      return .task {
        return try await agencyRepo.reissueCode(id: agency.id)
      }
      .map { .setInvitationCode($0) }
      .catch { return .just(.setError($0.toMMError)) }
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setUser(id, name):
      newState.userID = id
      newState.name = name
      
    case let .setAgency(agency):
      newState.agency = agency
      
    case let .setInvitationCode(code):
      newState.invitationCode = code
    
    case let .setMembers(members):
      newState.members = members
      
    case let .setRole(role):
      newState.role = role
      
    case let .setError(error):
      newState.error = error
    }
    return newState
  }
  
  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    return Observable.merge(mutation, serviceMutation)
  }
  
  private var serviceMutation: Observable<Mutation> {
    globalService.event.flatMap { event -> Observable<Mutation> in
      switch event {
      case let .updateAgency(agency):
        return .just(.setAgency(agency))
      }
    }
  }
  
  private func requestMyProfile() -> Observable<Mutation> {
    return .task {
      return try await userRepo.user()
    }
    .map { .setUser(id: $0.id, name: $0.nickname) }
    .catch { .just(.setError($0.toMMError)) }
  }
  
  private func requestInvitationCode() -> Observable<Mutation> {
    guard let agency = currentState.agency else {
      fatalError("소속이 없을 수 없음")
    }
    
    return .task {
      return try await agencyRepo.fetchCode(id: agency.id)
    }
    .map { .setInvitationCode($0) }
    .catch { return .just(.setError($0.toMMError)) }
  }
  
  private func requestMembers() -> Observable<Mutation> {
    guard let agency = currentState.agency else {
      fatalError("소속이 없을 수 없음")
    }
    
    return .task {
      return try await agencyRepo.fetchMemberList(id: agency.id)
    }
    .flatMap { [weak self] members -> Observable<Mutation> in
      guard let role = members.first(where: { $0.userID == self?.currentState.userID })?.role else {
        fatalError("역할이 없을 수 없음")
      }
      
      return .concat(
        .just(.setMembers(members)),
        .just(.setRole(role))
      )
    }
  }
}
