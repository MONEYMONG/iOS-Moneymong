import Foundation

public struct DeepLinkManager {

  public static var query: [String : Any]?
  public static var notiName: Notification.Name?

  public static func setQuery(_ query: [String : Any], notiName: Notification.Name) {
    guard !query.isEmpty else { return }

    self.query = query
    self.notiName = notiName

    NotificationCenter.default.post(
      name: notiName,
      object: nil,
      userInfo: query
    )
  }

  public static func clear() {
    query = nil
    notiName = nil
  }
}
