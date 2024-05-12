import Foundation

public struct LedgerDetail {
  let id: Int
  let storeInfo: String
  let amount: Int
  let fundType: FundType
  let description: String
  let paymentDate: String
  let receiptImageUrls: [ImageURL]
  let documentImageUrls: [ImageURL]
  let authorName: String
  
  public init(
    id: Int,
    storeInfo: String,
    amount: Int,
    fundType: FundType,
    description: String,
    paymentDate: String,
    receiptImageUrls: [ImageURL],
    documentImageUrls: [ImageURL],
    authorName: String
  ) {
    self.id = id
    self.storeInfo = storeInfo
    self.amount = amount
    self.fundType = fundType
    self.description = description
    self.paymentDate = paymentDate
    self.receiptImageUrls = receiptImageUrls
    self.documentImageUrls = documentImageUrls
    self.authorName = authorName
  }
  
  public struct ImageURL {
    let id: Int
    let url: String
  }
}
