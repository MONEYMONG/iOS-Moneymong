import Foundation

public struct LedgerDetail {
  public let id: Int
  public let storeInfo: String
  public let amount: Int
  public let fundType: FundType
  public let description: String
  public let paymentDate: String
  public let receiptImageUrls: [ImageURL]
  public let documentImageUrls: [ImageURL]
  public let authorName: String

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
  
  public struct ImageURL: Equatable {
    public let id: Int
    public let url: String

    public init(id: Int, url: String) {
      self.id = id
      self.url = url
    }
  }
}
