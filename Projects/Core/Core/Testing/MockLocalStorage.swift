import Core

public final class MockLocalStorage: LocalStorageInterface {
  public var recentLoginType: String?
  
  public var selectedAgency: Int?
  
  public var userID: Int?
  
  public var ledgerDateRange: [String : Int]?
  
  public var accessToken: String?
  
  public var refreshToken: String?
  
  public var socialAccessToken: String?
  
  public func removeAll() {
    selectedAgency = nil
    userID = nil

    recentLoginType = nil
    selectedAgency = nil

    accessToken = nil
    refreshToken = nil
  }
}
