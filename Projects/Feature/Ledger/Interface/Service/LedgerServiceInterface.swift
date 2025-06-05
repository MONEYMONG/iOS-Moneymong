/// Ledger에서 사용하는 전역서비스 모음
public protocol LedgerServiceInterface {
  var agency: AgencyServiceInterface { get }
  var member: MemberServiceInterface { get }
  var ledgerList: LedgerListServiceInterface { get }
}

