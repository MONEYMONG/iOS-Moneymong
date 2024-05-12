import Foundation

struct LedgerListResponseDTO: Responsable {
    let id: Int
    let totalBalance: Int
    let ledgerInfoViewDetails: [LedgerResponseDTO]
  
  var toEntity: LedgerList {
    return LedgerList(
      id: id,
      totalBalance: totalBalance,
      ledgers: ledgerInfoViewDetails.map { $0.toEntity }
    )
  }
}
