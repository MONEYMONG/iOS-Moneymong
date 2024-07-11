import Core

/// Ledger에서 사용하는 전역서비스 모음
protocol LedgerServiceInterface {
  var agency: AgencyServiceInterface { get }
  var member: MemberServiceInterface { get }
  var ledgerList: LedgerListServiceInterface { get }
}

final class LedgerService: LedgerServiceInterface {
  let agency: AgencyServiceInterface = AgencyService()
  let member: MemberServiceInterface = MemberService()
  let ledgerList: LedgerListServiceInterface = LedgerListService()
}
