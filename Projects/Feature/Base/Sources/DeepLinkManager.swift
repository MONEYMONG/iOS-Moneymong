import Foundation

public struct DeepLinkManager {
  
  public static var query: [String : Any]?
  
  // CreateLedger, LedgerDetail
  public static func setQuery(_ query: [String : Any], notiName: Notification.Name) {
    self.query = query
    
    NotificationCenter.default.post(
      name: notiName,
      object: nil,
      userInfo: query
    )
  }
  
  public static func clear() {
    query = nil
  }
}
