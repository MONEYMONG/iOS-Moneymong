import Foundation

enum AgencyAPI {
  case list // 소속목록조회
  case create(param: AgencyCreateRequestDTO) // 소속생성
  case memberList(id: Int) // 멤버목록조회
  case changeRole(id: Int, param: ChangeMemberRoleRequestDTO) // 멤버권한변경
  case kickout(id: Int, param: KickoutMemberRequestDTO) // 멤버 강제퇴장
  case myAgency // 내가 속한 소속 목록 조회
  case code(id: Int) // 초대코드 조회
  case certificateCode(id: Int, param: InvitationCodeCertificationRequestDTO) // 초대코드 인증
  case reissueCode(id: Int) // 초대코드 재발급
}

extension AgencyAPI: TargetType {
  var baseURL: URL? {
    return try? "https://dev.moneymong.site/api/v1/".asURL()
  }

  var path: String {
    switch self {
    case .list: return "agencies?size=20"
    case .create: return "agencies"
    case let .memberList(id): return "agencies/\(id)/agency-users"
    case let .changeRole(id, _): return "agencies/\(id)/agency-users/roles"
    case let .kickout(id, _): return "agencies/\(id)/agency-users/roles/block"
    case .myAgency: return "agencies/me"
    case let .code(id): return "agencies/\(id)/invitation-code"
    case let .certificateCode(id, _): return "agencies/\(id)/invitation-code"
    case let .reissueCode(id): return "agencies/\(id)/invitation-code"
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
    }
  }

  var task: HTTPTask {
    switch self {
    case .list: return .plain
    case let .create(param): return .requestJSONEncodable(params: param)
    case .memberList: return .plain
    case let .changeRole(_, param): return .requestJSONEncodable(params: param)
    case let .kickout(_, param): return .requestJSONEncodable(params: param)
    case .myAgency: return .plain
    case .code: return .plain
    case let .certificateCode(_, param): return .requestJSONEncodable(params: param)
    case .reissueCode: return .plain
    }
  }

  public var headers: [String: String]? {
    return [
      "Content-Type": "application/json;charset=UTF-8",
      "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJyb2xlIjoiUk9MRV9VU0VSIiwidXNlcklkIjozLCJpYXQiOjE3MDQ3MTU0NTEsImV4cCI6MTczNjI3MzA1MX0.2yYEy71Gz4YIz0DYzlx0glYMgZA0JAZs05jsVRvvQx4"
    ]
  }
}
