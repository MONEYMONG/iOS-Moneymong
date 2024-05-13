import ReactorKit

import DesignSystem
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
    @Pulse var snackBarMessage: String?
    @Pulse var destination: Destination?
    
    enum Destination {
      case kickOffAlert(memberID: Int)
    }
  }
  
  enum Action {
    case onappear
    case requestKickOffMember(Int)
    case reissueInvitationCode // 초대코드 재발급
    case tapCodeCopyButton // 초대코드 복사
  }
  
  enum Mutation {
    case setUser(id: Int, name: String)
    case setAgency(Agency)
    case setMembers([Member])
    case setRole(Member.Role)
    case setInvitationCode(String)
    case setDestination(State.Destination)
    case setError(MoneyMongError)
    case setSnackBarMessage(String)
  }
  
  let initialState: State = State()
  
  private let userRepo: UserRepositoryInterface
  private let agencyRepo: AgencyRepositoryInterface
  private let ledgerService: LedgerServiceInterface
  
  init(
    userRepo: UserRepositoryInterface,
    agencyRepo: AgencyRepositoryInterface,
    ledgerService: LedgerServiceInterface
  ) {
    self.userRepo = userRepo
    self.agencyRepo = agencyRepo
    self.ledgerService = ledgerService
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
      
    case .tapCodeCopyButton:
      let code = currentState.invitationCode ?? "000000"
      return .just(.setSnackBarMessage("초대코드 \(code)이 복사되었습니다"))
      
    case let .requestKickOffMember(memberID):
      guard let agency = currentState.agency else {
        fatalError("소속이 없을 수 없음")
      }

      return .task {
        try await agencyRepo.kickoutMember(id: agency.id, userId: memberID)
        return try await agencyRepo.fetchMemberList(id: agency.id)
      }
      .map { .setMembers($0) }
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
      newState.members = members.filter { $0.userID != state.userID }
      
    case let .setRole(role):
      newState.role = role
      
    case let .setDestination(value):
      newState.destination = value
      
    case let .setError(error):
      newState.error = error
      
    case let .setSnackBarMessage(message):
      newState.snackBarMessage = message
    }
    return newState
  }
  
  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    return Observable.merge(mutation, serviceMutation)
  }
  
  func transform(action: Observable<Action>) -> Observable<Action> {
    return Observable.merge(serviceAction, action)
  }
  
  // 맴버 역할 바뀌었을때, 화면업데이트
  private var serviceAction: Observable<Action> {
    ledgerService.member.event
      .flatMap { event -> Observable<Action> in
        switch event {
        case .updateRole:
          return .just(.onappear)
        case .kickOff:
          return .empty()
        }
      }
  }
  
  // 소속정보 바뀌었을때, 화면업데이트(TODO) + 맴버 내보내기 눌렀을때, Alert띄워주기
  private var serviceMutation: Observable<Mutation> {
    let memberStream = ledgerService.member.event.flatMap { event -> Observable<Mutation> in
      switch event {
      case .updateRole:
        return .just(.setSnackBarMessage("역할이 성공적으로 변경됐습니다"))
      case let .kickOff(id):
        return .just(.setDestination(.kickOffAlert(memberID: id)))
      }
    }
    
    let ledgerStream = ledgerService.agency.event.flatMap { event -> Observable<Mutation> in
      switch event {
      case let .update(agency):
        return .just(.setAgency(agency))
      }
    }
    
    return .merge(memberStream, ledgerStream)
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
