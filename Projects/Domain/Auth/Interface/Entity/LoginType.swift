public enum LoginType: String {
  case kakao
  case apple

  public var value: String {
    switch self {
    case .kakao: "KAKAO"
    case .apple: "APPLE"
    }
  }
}
