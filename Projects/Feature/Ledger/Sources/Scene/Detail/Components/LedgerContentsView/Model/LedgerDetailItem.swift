import NetworkService

struct LedgerDetailItem {
  var storeInfo: String
  var amount: String
  var fundType: FundType
  var memo: String
  var date: String
  var time: String
  var receiptImages: [LedgerImageSectionModel.Model]
  var documentImages: [LedgerImageSectionModel.Model]
  var authorName: String

  init(ledger: LedgerDetail?, formatter: ContentFormatter) {
    let (date, time) = formatter.convertToDateTime(with: ledger?.paymentDate ?? "")
    self.storeInfo = ledger?.storeInfo ?? ""
    self.amount = formatter.convertToAmount(with: ledger?.amount ?? 0) ?? "0"
    self.fundType = ledger?.fundType ?? .expense
    self.memo = ledger?.description ?? ""
    self.date = date
    self.time = time
    self.receiptImages = [
      LedgerImageSectionModel.Model.init(
        model: .default("영수증(최대12장)"),
        items: ledger?.receiptImageUrls.map { return .readImage($0.url) } ?? []
      )
    ]
    self.documentImages = [
      LedgerImageSectionModel.Model.init(
        model: .default("영수증(최대12장)"),
        items: ledger?.documentImageUrls.map { return .readImage($0.url) } ?? []
      )
    ]
    self.authorName = ledger?.authorName ?? ""
  }
}

extension LedgerDetailItem: Equatable {
  
}
