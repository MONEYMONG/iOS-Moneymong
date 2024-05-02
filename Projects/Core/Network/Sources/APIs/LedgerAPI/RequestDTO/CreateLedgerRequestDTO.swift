import Foundation

struct CreateLedgerRequestDTO: Encodable {
  let storeInfo: String
  let fundType: String
  let amount: Int
  let description: String
  let paymentDate: String
  let receiptImageUrls: [String]
  let documentImageUrls: [String]
}


