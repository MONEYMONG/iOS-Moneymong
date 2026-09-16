import Foundation

public enum Config {
#if DEBUG
  public static let base = "https://dev.moneymong.site/api/"
  public static let webBase = "https://dev.moneymong.site"
#else
  public static let base = "https://prod.moneymong.site/api/"
  public static let webBase = "https://prod.moneymong.site"
#endif

  public static let invitationPath = "/invite"

  public static func invitationURL(code: String, agencyID: Int) -> String? {
    var components = URLComponents(string: webBase + invitationPath)
    components?.queryItems = [
      URLQueryItem(name: "code", value: code),
      URLQueryItem(name: "agencyID", value: String(agencyID))
    ]
    return components?.url?.absoluteString
  }
}
