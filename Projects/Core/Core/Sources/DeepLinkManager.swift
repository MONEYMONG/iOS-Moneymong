import Foundation

public struct DeepLinkManager {
  
  public static var destination: String?
  
  // OCR, CreateLedger, LedgerDetail
  public static func setDestination(_ urlString: String) {
    let query = urlString.replacingOccurrences(of: "widget://", with: "")
    destination = query
    
    NotificationCenter.default.post(name: .init("deeplink"), object: nil, userInfo: ["query": query])
  }
  
  public static func clear() {
    destination = nil
  }
}
