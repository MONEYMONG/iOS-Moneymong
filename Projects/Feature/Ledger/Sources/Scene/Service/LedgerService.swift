/// Ledger에서 사용하는 전역서비스 모음
public protocol LedgerServiceInterface {
  var agency: AgencyServiceInterface { get }
  var member: MemberServiceInterface { get }
  var ledgerList: LedgerListServiceInterface { get }
}

public final class LedgerService: LedgerServiceInterface {
  public let agency: AgencyServiceInterface = AgencyService()
  public let member: MemberServiceInterface = MemberService()
  public let ledgerList: LedgerListServiceInterface = LedgerListService()
  
  public init() {}
}
