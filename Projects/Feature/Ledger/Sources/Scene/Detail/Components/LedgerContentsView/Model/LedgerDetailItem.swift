import NetworkService

struct LedgerDetailItem {
  let id: Int
  var storeInfo: String
  var amount: String
  var fundType: FundType
  var memo: String
  var date: String
  var time: String
  var receiptImages: [LedgerImageSectionModel.Model]
  var documentImages: [LedgerImageSectionModel.Model]
  var authorName: String

  private let formatter: ContentFormatter

  init(ledger: LedgerDetail?, formatter: ContentFormatter) {
    self.formatter = formatter

    let (date, time) = formatter.convertToDateTime(with: ledger?.paymentDate ?? "")

    self.id = ledger?.id ?? 0
    self.storeInfo = ledger?.storeInfo ?? ""
    self.amount = formatter.convertToAmount(with: ledger?.amount ?? 0) ?? "0"
    self.fundType = ledger?.fundType ?? .expense
    self.memo = ledger?.description ?? ""
    self.date = date
    self.time = time
    self.receiptImages = [
      LedgerImageSectionModel.Model.init(
        model: .default("영수증(최대12장)"),
        items: ledger?.receiptImageUrls.count == 0
        ? [.description("내용없음")]
        : ledger?.receiptImageUrls.map { return .image($0.url) } ?? []
      )
    ]
    self.documentImages = [
      LedgerImageSectionModel.Model.init(
        model: .default("영수증(최대12장)"),
        items: ledger?.documentImageUrls.count == 0
        ? [.description("내용없음")]
        : ledger?.documentImageUrls.map { return .image($0.url) } ?? []
      )
    ]
    self.authorName = ledger?.authorName ?? ""
  }

  var toEntity: LedgerDetail {
    .init(
      id: id,
      storeInfo: storeInfo,
      amount: Int(amount.filter { $0.isNumber }) ?? 0,
      fundType: fundType,
      description: memo,
      paymentDate: formatter.convertToISO8601(date: date, time: time) ?? "",
      receiptImageUrls: [],
      documentImageUrls: [],
      authorName: authorName
    )
  }
}

extension LedgerDetailItem: Equatable {
  static func == (lhs: LedgerDetailItem, rhs: LedgerDetailItem) -> Bool {
    if lhs.id == rhs.id && lhs.storeInfo == rhs.storeInfo && lhs.amount == rhs.amount
        && lhs.fundType == rhs.fundType && lhs.date == rhs.date && lhs.time == rhs.time
        && lhs.memo == rhs.memo {
      return true
    }
    return false
  }
}
