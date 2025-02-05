import Foundation

import MMStorageInterface

public final class LocalStorage: LocalStorageInterface {
  public init() {}
  
  @UD(key: .recentLoginType)
  public var recentLoginType: String?
  
  @UD(key: .selectedAgency)
  public var selectedAgency: Int?
  
  @UD(key: .userID)
  public var userID: Int?
  
  @UD(key: .ledgerDateRange)
  public var ledgerDateRange: [String:Int]?
  
  @Keychain(key: .accessToken)
  public var accessToken: String?
  
  @Keychain(key: .refreshToken)
  public var refreshToken: String?
  
  @Keychain(key: .socialAccessToken)
  public var socialAccessToken: String?
  
  public func removeAll() {
    ledgerDateRange = nil
    userID = nil

    recentLoginType = nil
    selectedAgency = nil

    accessToken = nil
    refreshToken = nil
    socialAccessToken = nil
  }
  
  public func saveCurrentLedgerInfo(agencyName: String, totalBalance: Int) {
    let dic: [String: Any] = [
      "name" : agencyName,
      "total" : totalBalance
    ]
    
    UserDefaults(suiteName: "group.moneymong")?.set(dic, forKey: "agencyInfo")
  }
  
  public func deleteCurrentLedgerInfo() {
    UserDefaults(suiteName: "group.moneymong")?.removeObject(forKey: "agencyInfo")
  }
}
