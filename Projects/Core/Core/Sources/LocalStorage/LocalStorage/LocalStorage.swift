import Foundation

public protocol LocalStorageInterface: AnyObject {
  var recentLoginType: String? { get set }
  var selectedAgency: Int? { get set }
  var userID: Int? { get set }
  var ledgerDateRange: [String:Int]? { get set }
  
  var accessToken: String? { get set }
  var refreshToken: String? { get set }
  var socialAccessToken: String? { get set }
  
  func removeAll()
}

public final class LocalStorage: LocalStorageInterface {

  public init() {
    
  }
  
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
    selectedAgency = nil
    userID = nil

    recentLoginType = nil
    selectedAgency = nil

    accessToken = nil
    refreshToken = nil
  }
}
