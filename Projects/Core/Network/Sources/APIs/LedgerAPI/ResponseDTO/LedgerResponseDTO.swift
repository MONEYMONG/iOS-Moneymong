import Foundation

struct LedgerResponseDTO: Responsable {
  let id: Int
  let storeInfo: String
  let fundType: String
  let amount: Int
  let balance: Int
  let order: Int
  let paymentDate: String
  
  var toEntity: Ledger {
    return Ledger(
      id: id,
      storeInfo: storeInfo,
      fundType: FundType(rawValue: fundType)!,
      amount: amount,
      balance: balance,
      order: order,
      paymentDate: paymentDate
    )
  }
}

