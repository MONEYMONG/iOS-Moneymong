import ReactorKit

import DesignSystem
import Core

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
      case agencyDeleteAlert
      case ledgerTab
    }
  }
  
  enum Action {
    case onappear
    case requestKickOffMember(Int)
    case reissueInvitationCode // 초대코드 재발급
    case tapCodeCopyButton // 초대코드 복사
    case tapAgencyDeleteButton // 소속삭제 얼럿 present
    case tapAgnecyDeleteAlertButton // 소속삭제 얼럿 -> 소속삭제
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
        debugPrint("agencyID가 없을 수 없음")
        return .empty()
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
        debugPrint("agencyID가 없을 수 없음")
        return .empty()
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
    case .tapAgencyDeleteButton:
      return .just(.setDestination(.agencyDeleteAlert))
    case .tapAgnecyDeleteAlertButton:
      return .task {
        guard let id = currentState.agencyID else {
          throw MoneyMongError.appError(.default, errorMessage: "소속을 삭제할 수 없습니다\n잠시 후 다시 시도해 주세요")
        }
        try await agencyRepo.deleteAgency(id: id)
        let selectedAgency = try await agencyRepo.fetchMyAgency().first
        userRepo.updateSelectedAgency(id: selectedAgency?.id)
        ledgerService.agency.updateAgency(selectedAgency)
        return .setDestination(.ledgerTab)
      }
      .catch { return .just(.setError($0.toMMError)) }
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
  
  private var serviceMutation: Observable<Mutation> {
    // 멤버 정보 변경됬을때 업데이트
    let memberStream = ledgerService.member.event.flatMap { [weak self] event -> Observable<Mutation> in
      guard let self else { return .empty() }
      
      switch event {
      case .updateRole:
        return .concat(
          requestMembers(agencyID: currentState.agencyID),
          .just(.setSnackBarMessage("역할이 성공적으로 변경됐습니다"))
        )
      case let .kickOff(id):
        return .just(.setDestination(.kickOffAlert(memberID: id)))
      }
    }
    
    // 소속정보 변경됬을때 업데이트
    let agencyStream = ledgerService.agency.event.flatMap { [weak self] event -> Observable<Mutation> in
      guard let self else { return .empty() }
      
      switch event {
      case let .update(agency):
        if currentState.agencyID == agency?.id {
          return .empty()
        } else if let id = agency?.id {
          return .concat(
            .just(.setAgencyID(id)),
            .just(.setLoading(true)),
            requestInvitationCode(agencyID: id),
            requestMembers(agencyID: id),
            .just(.setLoading(false))
          )
        } else {
          return .empty()
        }
      }
    }
    
    return .merge(memberStream, agencyStream)
  }
  
  /// 내정보 조회
  private func requestMyProfile() -> Observable<Mutation> {
    return .task { try await userRepo.user() }
      .map { .setName($0.nickname) }
      .catch { .just(.setError($0.toMMError)) }
  }
  
  /// 초대코드 조회
  private func requestInvitationCode(agencyID: Int?) -> Observable<Mutation> {
    guard let agencyID else {
      debugPrint("agencyID가 없을 수 없음")
      return .empty()
    }
    return .task { try await agencyRepo.fetchCode(id: agencyID) }
      .map { .setInvitationCode($0) }
      .catch { return .just(.setError($0.toMMError)) }
  }
  
  /// 소속에 속한 멤버리스트 조회
  private func requestMembers(agencyID: Int?) -> Observable<Mutation> {
    guard let agencyID else {
      debugPrint("agencyID가 없을 수 없음")
      return .empty()
    }
    return .task { try await agencyRepo.fetchMemberList(id: agencyID) }
      .flatMap { [weak self] members -> Observable<Mutation> in
        guard let role = members.first(where: { $0.userID == self?.currentState.userID })?.role
        else {
          debugPrint("역할이 없을 수 없음")
          return .empty()
        }
        
        return .concat(
          .just(.setMembers(members)),
          .just(.setRole(role))
        )
      }
  }
}
