import Foundation

struct LedgerListResponseDTO: Responsable {
  let id: Int
  let ledgerDetailTotalCount :Int
  let totalBalance: Int
  let ledgerInfoViewDetails: [LedgerResponseDTO]
  
  var toEntity: LedgerList {
    return LedgerList(
      totalBalance: totalBalance,
      totalCount: ledgerDetailTotalCount,
      ledgers: ledgerInfoViewDetails.map { $0.toEntity }
    )
  }
}
