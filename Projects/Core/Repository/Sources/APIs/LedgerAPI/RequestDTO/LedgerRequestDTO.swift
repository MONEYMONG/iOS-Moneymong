import Foundation

struct LedgerRequestDTO: Encodable {
  let storeInfo: String
  let fundType: String
  let amount: Int
  let description: String
  let paymentDate: String
  let documentImageUrls: [String]
}
