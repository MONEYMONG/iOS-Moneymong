import NetworkService

struct LedgerDetailItem: Equatable {
  static func == (lhs: LedgerDetailItem, rhs: LedgerDetailItem) -> Bool {
    if
      lhs.storeInfo == rhs.storeInfo
        && lhs.amount == rhs.amount
        && lhs.fundType == rhs.fundType
        && lhs.memo == rhs.memo
        && lhs.date == rhs.date
        && lhs.time == rhs.time
        //        && lhs.receiptImageUrls
        && lhs.authorName == rhs.authorName
    {
      return true
    }
    return false
  }

  let storeInfo: String
  let amount: String
  let fundType: FundType
  let memo: String
  let date: String
  let time: String
  let receiptImageUrls: [LedgerDetail.ImageURL]
  let documentImageUrls: [LedgerDetail.ImageURL]
  let authorName: String
}
