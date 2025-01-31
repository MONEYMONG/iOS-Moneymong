import Foundation

public struct DeepLinkManager {
  
  public static var destination: String?
  
  // OCR, CreateLedger, LedgerDetail
  public static func setDestination(_ urlString: String, agencyID: Int?) {
    let query = urlString.replacingOccurrences(of: "widget://", with: "")
    destination = query
    
    guard let agencyID else { return }
    
    NotificationCenter.default.post(
      name: .init("deeplink"),
      object: nil,
      userInfo: [
        "query": query,
        "agencyID": agencyID
      ]
    )
  }
  
  public static func clear() {
    destination = nil
  }
}
