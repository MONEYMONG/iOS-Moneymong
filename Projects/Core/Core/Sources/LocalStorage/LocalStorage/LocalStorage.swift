import Foundation

public protocol LocalStorageInterface: AnyObject {
  var recentLoginType: String? { get set }
  var selectedAgency: Int? { get set }
  var userID: Int? { get set }
  
  var accessToken: String? { get set }
  var refreshToken: String? { get set }
  var socialAccessToken: String? { get set }
  
  func removeAll()
}

#if DEBUG
public final class MockLocalStorage: LocalStorageInterface {
  public var recentLoginType: String?
  
  public var selectedAgency: Int?
  
  public var userID: Int?
  
  public var accessToken: String?
  
  public var refreshToken: String?
  
  public var socialAccessToken: String?
  
  public init() {}
  
  public func removeAll() {
    selectedAgency = nil
    userID = nil

    recentLoginType = nil
    selectedAgency = nil

    accessToken = nil
    refreshToken = nil
  }
}
#endif

public final class LocalStorage: LocalStorageInterface {

  @UD(key: .recentLoginType)
  public var recentLoginType: String?
  
  @UD(key: .selectedAgency)
  public var selectedAgency: Int?
  
  @UD(key: .userID)
  public var userID: Int?
  
  @Keychain(key: .accessToken)
  public var accessToken: String?
  
  @Keychain(key: .refreshToken)
  public var refreshToken: String?
  
  @Keychain(key: .socialAccessToken)
  public var socialAccessToken: String?
  
  public init() { }
  
  public func removeAll() {
    selectedAgency = nil
    userID = nil

    recentLoginType = nil
    selectedAgency = nil

    accessToken = nil
    refreshToken = nil
  }
}
