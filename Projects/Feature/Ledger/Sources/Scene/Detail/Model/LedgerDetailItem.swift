import NetworkService

struct LedgerDetailItem: Equatable {
  static func == (lhs: LedgerDetailItem, rhs: LedgerDetailItem) -> Bool {
    if
      lhs.id == rhs.id
        && lhs.storeInfo == rhs.storeInfo
        && lhs.amountText == rhs.amountText
        && lhs.fundType == rhs.fundType
        && lhs.memo == rhs.memo
        && lhs.paymentDate == rhs.paymentDate
        && lhs.paymentTime == rhs.paymentTime
//        && lhs.receiptImageUrls
        && lhs.authorName == rhs.authorName
     {
      return true
    }
    return false
  }

  let id: Int
  let storeInfo: String
  let amountText: String
  let fundType: FundType
  let memo: String
  let paymentDate: String
  let paymentTime: String
  let receiptImageUrls: [LedgerDetail.ImageURL]
  let documentImageUrls: [LedgerDetail.ImageURL]
  let authorName: String
}
