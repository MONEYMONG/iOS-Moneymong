import LedgerFeatureInterface

public final class LedgerService: LedgerServiceInterface {
  public let agency: AgencyServiceInterface = AgencyService()
  public let member: MemberServiceInterface = MemberService()
  public let ledgerList: LedgerListServiceInterface = LedgerListService()
  
  public init() {}
}
