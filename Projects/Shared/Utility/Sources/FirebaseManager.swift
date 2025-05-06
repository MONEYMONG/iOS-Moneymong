import Foundation

import FirebaseCore
import FirebaseAnalytics

public class FirebaseManager: NSObject {
  public enum EventType: String {
    case signUp = "sign_up" /// 회원가입 *
    case logout = "logout" /// 로그아웃 *
    case login = "login" /// 로그인 *
    case registerUniversity = "register_university" /// 대학 등록 *
    case kakaoLogin = "kakao_login" /// 카카오 로그인 *
    case appleLogin = "apple_login" /// 애플 로그인 *
    case deleteAccount = "delete_account" /// 회원탈퇴 *

    case didTapCreateAgency = "did_tap_create_agency" /// 소속 생성 버튼 클릭 *
    case deleteAgency = "delete_agency" /// 소속 삭제 *
    case createAgency = "create_agency" /// 소속 생성 *
    case joinAgency = "join_agency" /// 소속 가입 *

    case didTapManualInput = "did_tap_manual_input" /// 장부 수동 입력 버튼 클릭 *
    case createLedgerItem = "create_ledger_item" /// 장부 내역 생성 *
    case updateLedgerItem = "update_ledger_item" /// 장부 내역 수정 *
    case deleteLedgerItem = "delete_ledger_item" /// 장부 내역 삭제 *
    case didTapSelectDate = "did_tap_select_date" /// 날짜 선택 버튼 클릭 *

    case kickoutMember = "kickout_member" /// 멤버 추방
  }
  
  public static var shared = FirebaseManager()

  public func initSDK() {
    FirebaseApp.configure()
  }

  public func setUser(id: String) {
    Analytics.setUserID(id)
  }

  public func logEvent(event: EventType, parameters: [String: Any]? = nil) {
    Analytics.logEvent(event.rawValue, parameters: parameters)
  }
}
