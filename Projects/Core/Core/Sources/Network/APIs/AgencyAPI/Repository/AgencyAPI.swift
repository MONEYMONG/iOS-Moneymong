import Foundation

enum AgencyAPI {
  case list(param: AgencyListRequestDTO) // 소속목록조회
  case create(param: AgencyCreateRequestDTO) // 소속생성
  case memberList(id: Int) // 멤버목록조회
  case changeRole(id: Int, param: ChangeMemberRoleRequestDTO) // 멤버권한변경
  case kickout(id: Int, param: KickoutMemberRequestDTO) // 멤버 강제퇴장
  case myAgency // 내가 속한 소속 목록 조회
  case code(id: Int) // 초대코드 조회
  case certificateCode(id: Int, param: InvitationCodeCertificationRequestDTO) // 초대코드 인증
  case reissueCode(id: Int) // 초대코드 재발급
  case delete(id: Int) // 소속삭제
}

extension AgencyAPI: TargetType {
  var baseURL: URL? {
    return try? Config.base.asURL()
  }

  var path: String {
    switch self {
    case .list: return "v1/agencies"
    case .create: return "v1/agencies"
    case let .memberList(id): return "v1/agencies/\(id)/agency-users"
    case let .changeRole(id, _): return "v1/agencies/\(id)/agency-users/roles"
    case let .kickout(id, _): return "v1/agencies/\(id)/agency-users/roles/block"
    case .myAgency: return "v1/agencies/me"
    case let .code(id): return "v1/agencies/\(id)/invitation-code"
    case let .certificateCode(id, _): return "v1/agencies/\(id)/invitation-code"
    case let .reissueCode(id): return "v1/agencies/\(id)/invitation-code"
    case let .delete(id): return "v1/agencies/\(id)"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .list: return .get
    case .create: return .post
    case .memberList: return .get
    case .changeRole: return .patch
    case .kickout: return .patch
    case .myAgency: return .get
    case .code: return .get
    case .certificateCode: return .post
    case .reissueCode: return .patch
    case .delete: return .delete
    }
  }

  var task: HTTPTask {
    switch self {
    case let .list(param): return .requestJSONEncodable(query: param)
    case let .create(param): return .requestJSONEncodable(params: param)
    case .memberList: return .plain
    case let .changeRole(_, param): return .requestJSONEncodable(params: param)
    case let .kickout(_, param): return .requestJSONEncodable(params: param)
    case .myAgency: return .plain
    case .code: return .plain
    case let .certificateCode(_, param): return .requestJSONEncodable(params: param)
    case .reissueCode: return .plain
    case .delete: return .plain
    }
  }

  public var headers: [String: String]? {
    return [
      "Content-Type": "application/json;charset=UTF-8"]
  }
}
