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
  }
}

extension LedgerDetail: Equatable {
  public static func == (lhs: LedgerDetail, rhs: LedgerDetail) -> Bool {
    if lhs.id == rhs.id && lhs.storeInfo == rhs.storeInfo && lhs.amount == rhs.amount
        && lhs.fundType == rhs.fundType && lhs.paymentDate == rhs.paymentDate
        && lhs.description == rhs.description && lhs.receiptImageUrls == rhs.receiptImageUrls
        && lhs.documentImageUrls == rhs.documentImageUrls && lhs.authorName == rhs.authorName
    {
      return true
    }
    return false
  }
}
