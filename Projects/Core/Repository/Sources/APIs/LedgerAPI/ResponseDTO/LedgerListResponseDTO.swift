import Foundation

import BaseDomain
import MMNetworkInterface

struct LedgerListResponseDTO: Responsable {
  let id: Int
  let ledgerDetailTotalCount :Int
  let totalBalance: Int
  let ledgerInfoViewDetails: [LedgerResponseDTO]
  let agencyName: String
  
  var toEntity: LedgerList {
    return LedgerList(
      totalBalance: totalBalance,
      totalCount: ledgerDetailTotalCount,
      ledgers: ledgerInfoViewDetails.map { $0.toEntity }
    )
  }
}
