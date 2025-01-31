import Repository

public final class MockLocalStorage: LocalStorageInterface {
  public var recentLoginType: String?
  
  public var selectedAgency: Int?
  
  public var userID: Int?
  
  public var ledgerDateRange: [String : Int]?
  
  public var accessToken: String?
  
  public var refreshToken: String?
  
  public var socialAccessToken: String?
  
  public var currentLedgerInfo: [String : Any]?
  
  public func removeAll() {
    selectedAgency = nil
    userID = nil

    recentLoginType = nil
    selectedAgency = nil

    accessToken = nil
    refreshToken = nil
  }
  
  public func saveCurrentLedgerInfo(agencyName: String, totalBalance: Int) {
    currentLedgerInfo = ["agencyName": agencyName, "totalBalance": totalBalance]
  }
  
  public func deleteCurrentLedgerInfo() {
    currentLedgerInfo = nil
  }
}
