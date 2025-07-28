import Foundation

public enum MoneyMongError: LocalizedError, Equatable {
  public enum Code: String {
    case global_400 = "GLOBAL-400"
    case global_403 = "GLOBAL-403"
    case global_500 = "GLOBAL-500"
    case user_001 = "USER-001"
    case user_002 = "USER-002"
    case agencyUser_001 = "AGENCY-USER-001"
    case agencyUser_002 = "AGENCY-USER-002"
    case agencyUser_003 = "AGENCY-USER-003"
    case agencyUser_004 = "AGENCY-USER-004"
    case ledger_001 = "LEDGER-001"
    case ledger_002 = "LEDGER-002"
    case ledger_003 = "LEDGER-003"
    case ledger_004 = "LEDGER-004"
    case ledger_005 = "LEDGER-005"
    case ledger_006 = "LEDGER-006"
    case ledger_007 = "LEDGER-007"
    case ledger_008 = "LEDGER-008"
    case image_001 = "IMAGE-001"
    case image_002 = "IMAGE-002"
    case token_001 = "TOKEN-001"
    case token_002 = "TOKEN-002"
    case token_003 = "TOKEN-003"
    case token_004 = "TOKEN-004"
    case login_001 = "LOGIN-001"
    case login_002 = "LOGIN-002"
    case invitation_001 = "INVITATION-001"
    case invitation_002 = "INVITATION-002"
    case invitation_003 = "INVITATION-003"
    case network_001 = "NETWORK-001"
    case `default`
  }
  case networkError(errorMessage: String)
  case serverError(errorMessage: String)
  case appError(Code)
  case `default`(String)
  
  public var errorTitle: String {
    switch self {
    case let .appError(code):
      switch code {
      case .global_400: "잘못된 요청입니다."
      case .global_403: "접근 권한이 없습니다."
      case .global_500, .network_001, .default: "잠시후에 다시 시도해주세요!"
      case .user_001, .user_002: "존재하지 않는 사용자예요"
      case .agencyUser_001: "사용자가 없는 장부예요"
      case .agencyUser_002: "잘못된 접근이에요\n다시 한 번 확인해주세요!"
      case .agencyUser_003: "더이상 해당 장부의 멤버가\n아니기 때문에 접근이 불가능해요"
      case .agencyUser_004: "이미 가입된 사용자예요"
      case .ledger_001: "장부에 참여한 사용자만 이용이 가능해요"
      case .ledger_002: "잘못된 접근이에요\n다시 한 번 확인해주세요!"
      case .ledger_003: "장부가 존재하지 않습니다"
      case .ledger_004: "장부 상세 내역이 존재하지 않습니다"
      case .ledger_006: "장부 영수증 내역이 존재하지 않습니다"
      case .ledger_007: "장부 증빙 자료 내역이 존재하지 않습니다"
      case .ledger_005, .ledger_008: "기록할 수 있는 총 잔액을 초과했습니다"
      case .image_001: "이미지를 찾을 수 없습니다."
      case .image_002: "이미지 불러오기를 실패했어요\n다시 시도해주세요!"
      case .token_001, .token_002, .token_003, .token_004: "로그인 정보가 만료되었어요\n다시 로그인해 주세요!"
      case .login_001: "잘못된 접근이에요\n다시 한 번 확인해주세요!"
      case .login_002: "로그인 정보가 유효하지 않아요\n다시 로그인해 주세요!"
      case .invitation_001, .invitation_002, .invitation_003: "잘못된 초대코드에요\n다시 입력해주세요!"
      }
    case let .default(title): title
    default: "에러"
    }
  }
  
  public var errorDescription: String? {
    switch self {
    case .networkError: "네트워크 연결을 확인해주세요"
    case .serverError(let errorMessage): errorMessage
    case .appError(let code):
      switch code {
      case .ledger_005: "총 잔액은 최대 999,999,999원까지 기록이 가능합니다"
      case .ledger_008: "총 잔액은 최소 -999,999,999원까지 기록이 가능합니다"
      default: nil
      }
    case .default: nil
    }
  }
}

public extension Error {
  var toMMError: MoneyMongError {
    return self as? MoneyMongError ?? .default(localizedDescription)
  }
}
