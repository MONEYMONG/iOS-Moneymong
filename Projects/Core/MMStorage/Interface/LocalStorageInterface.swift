
public protocol LocalStorageInterface: AnyObject {
  var recentLoginType: String? { get set }
  var selectedAgency: Int? { get set }
  var userID: Int? { get set }
  var ledgerDateRange: [String:Int]? { get set }
  
  var accessToken: String? { get set }
  var refreshToken: String? { get set }
  var socialAccessToken: String? { get set }
  
  func removeAll()
  func saveCurrentLedgerInfo(agencyName: String, totalBalance: Int)
  func deleteCurrentLedgerInfo()
}
