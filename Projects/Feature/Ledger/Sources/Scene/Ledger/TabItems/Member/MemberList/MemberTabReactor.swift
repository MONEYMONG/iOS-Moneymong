import ReactorKit

import DesignSystem
import NetworkService

final class MemberTabReactor: Reactor {
  
  struct State {
    let userID: Int
    @Pulse var agencyID: Int?
    
    @Pulse var name: String?
    @Pulse var role: Member.Role?
    @Pulse var invitationCode: String?
    @Pulse var members: [Member] = []
    
    @Pulse var isLoading = false
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
    case setName(String)
    case setAgencyID(Int)
    case setMembers([Member])
    case setRole(Member.Role)
    case setInvitationCode(String)
    case setLoading(Bool)
    case setDestination(State.Destination)
    case setError(MoneyMongError)
    case setSnackBarMessage(String)
  }
  
  let initialState: State
  
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
    self.initialState = .init(
      userID: userRepo.fetchUserID(),
      agencyID: userRepo.fetchSelectedAgency()
    )
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .onappear:
      return .concat(
        .just(.setLoading(true)),
          .merge(
            requestMyProfile(),
            requestInvitationCode(agencyID: currentState.agencyID),
            requestMembers(agencyID: currentState.agencyID)
          ),
        
          .just(.setLoading(false))
      )
      
    case .reissueInvitationCode:
      guard let agencyID = currentState.agencyID else {
        fatalError("agencyID가 없을 수 없음")
      }
      
      return .concat(
        .just(.setLoading(true)),
        
        .concat(
          .task { try await agencyRepo.reissueCode(id: agencyID) }
            .map { .setInvitationCode($0) }
            .catch { return .just(.setError($0.toMMError)) },
          .just(.setSnackBarMessage("초대코드가 재발급 되었습니다."))
        ),
        
        .just(.setLoading(false))
      )
      
    case .tapCodeCopyButton:
      let code = currentState.invitationCode ?? "000000"
      return .just(.setSnackBarMessage("초대코드 \(code)이 복사되었습니다"))
      
    case let .requestKickOffMember(memberID):
      guard let agencyID = currentState.agencyID else {
        fatalError("agencyID가 없을 수 없음")
      }
      
      return .concat(
        .just(.setLoading(true)),
        
        .task {
          try await agencyRepo.kickoutMember(id: agencyID, userId: memberID)
          return try await agencyRepo.fetchMemberList(id: agencyID)
        }
        .map { .setMembers($0) }
        .catch { return .just(.setError($0.toMMError)) },
        
        .just(.setLoading(false))
      )
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setName(name):
      newState.name = name
      
    case let .setAgencyID(id):
      newState.agencyID = id
      
    case let .setInvitationCode(code):
      newState.invitationCode = code
      
    case let .setMembers(members):
      newState.members = members.filter { $0.userID != state.userID }
      
    case let .setRole(role):
      newState.role = role
      
    case let .setLoading(value):
      newState.isLoading = value
      
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
    return ledgerService.member.event
      .flatMap { event -> Observable<Action> in
        switch event {
        case .updateRole:
          return .just(.onappear)
        case .kickOff:
          return .empty()
        }
      }
  }
  
  // 맴버 내보내기 눌렀을때, Alert띄워주기 + 소속정보 바뀌었을때 업데이트
  private var serviceMutation: Observable<Mutation> {
    let memberStream = ledgerService.member.event.flatMap { event -> Observable<Mutation> in
      switch event {
      case .updateRole:
        return .just(.setSnackBarMessage("역할이 성공적으로 변경됐습니다"))
      case let .kickOff(id):
        return .just(.setDestination(.kickOffAlert(memberID: id)))
      }
    }
    
    let agencyStream = ledgerService.agency.event.flatMap { [weak self] event -> Observable<Mutation> in
      guard let self else { return .empty() }
      switch event {
      case let .update(agency):
        if currentState.agencyID == agency.id {
          return .empty()
        } else {
          return .concat(
            .just(.setAgencyID(agency.id)),
            .just(.setLoading(true)),
            requestInvitationCode(agencyID: agency.id),
            requestMembers(agencyID: agency.id),
            .just(.setLoading(false))
          )
        }
      }
    }
    
    return .merge(memberStream, agencyStream)
  }
  
  private func requestMyProfile() -> Observable<Mutation> {
    return .task { try await userRepo.user() }
      .map { .setName($0.nickname) }
      .catch { .just(.setError($0.toMMError)) }
  }
  
  private func requestInvitationCode(agencyID: Int?) -> Observable<Mutation> {
    guard let agencyID else {
      debugPrint("agencyID가 없을 수 없음")
      return .empty()
    }
    return .task { try await agencyRepo.fetchCode(id: agencyID) }
      .map { .setInvitationCode($0) }
      .catch { return .just(.setError($0.toMMError)) }
  }
  
  private func requestMembers(agencyID: Int?) -> Observable<Mutation> {
    guard let agencyID else {
      debugPrint("agencyID가 없을 수 없음")
      return .empty()
    }
    return .task { try await agencyRepo.fetchMemberList(id: agencyID) }
      .flatMap { [weak self] members -> Observable<Mutation> in
        guard let role = members.first(where: { $0.userID == self?.currentState.userID })?.role
        else {
          fatalError("역할이 없을 수 없음")
        }
        
        return .concat(
          .just(.setMembers(members)),
          .just(.setRole(role))
        )
      }
  }
}
