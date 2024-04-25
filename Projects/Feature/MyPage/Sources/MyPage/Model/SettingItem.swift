import UIKit

import DesignSystem

/// SettingCell의 데이터모델
enum SettingItem: Equatable {
  case service
  case privacy
  case withdrawal
  case logout
  case versionInfo
  
  enum AccesoryType: Equatable {
    case disclosureIndicator
    case version
    case no
  }
  
  var icon: UIImage? {
    switch self {
    case .service: return Images.paper
    case .privacy: return Images.document
    case .withdrawal: return Images.trash
    case .logout: return Images.logout
    case .versionInfo: return Images.warning
    }
  }
  
  var title: String {
    switch self {
    case .service: return "서비스 이용약관"
    case .privacy: return "개인정보 처리 방침"
    case .withdrawal: return "회원탈퇴"
    case .logout: return "로그아웃"
    case .versionInfo: return "버전정보"
    }
  }
  
  var accessoryType: AccesoryType {
    switch self {
    case .service: return .disclosureIndicator
    case .privacy: return .disclosureIndicator
    case .withdrawal: return .disclosureIndicator
    case .logout: return .no
    case .versionInfo: return .version
    }
  }
}
