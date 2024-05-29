import NetworkService

/// 화면에 보여주기 위한 용도로 가공한 아이템
struct LedgerDetailItem {
  let id: Int
  var storeInfo: String
  var amount: String
  var fundType: FundType
  var memo: String
  var date: String
  var time: String
  var receiptImages: LedgerImageSectionModel.Model
  var addedReceiptImages: [LedgerImageInfo] = []
  var deletedReceiptImages: [LedgerImageInfo] = []
  var documentImages: LedgerImageSectionModel.Model
  var addedDocumentImages: [LedgerImageInfo] = []
  var deletedDocumentImages: [LedgerImageInfo] = []
  var authorName: String

  private let formatter = ContentFormatter()

  init(ledger: LedgerDetail) {
    let (date, time) = formatter.convertToDateTime(with: ledger.paymentDate)

    self.id = ledger.id
    self.storeInfo = ledger.storeInfo
    self.amount = formatter.convertToAmount(with: ledger.amount) ?? "0"
    self.fundType = ledger.fundType
    self.memo = ledger.description
    self.date = date
    self.time = time
    self.receiptImages = .init(
      model: .default("영수증(최대12장)"),
      items: ledger.receiptImageUrls.count == 0
      ? [.description("내용없음")]
      : ledger.receiptImageUrls.map { return .image(.init(
        imageSection: .receipt, key: "\($0.id)", url: $0.url
      )) }
    )
    self.documentImages = .init(
      model: .default("증빙자료(최대12장)"),
      items: ledger.documentImageUrls.count == 0
      ? [.description("내용없음")]
      : ledger.documentImageUrls.map { return .image(.init(
        imageSection: .document, key: "\($0.id)", url: $0.url
      )) }
    )
    self.authorName = ledger.authorName
  }

  var toEntity: LedgerDetail {
    return .init(
      id: id,
      storeInfo: storeInfo,
      amount: Int(amount.filter { $0.isNumber }) ?? 0,
      fundType: fundType,
      description: memo,
      paymentDate: formatter.convertToISO8601(date: date, time: time) ?? "",
      receiptImageUrls: receiptImages.items
        .compactMap { item -> LedgerDetail.ImageURL? in
          if case .image(let imageInfo) = item {
            return .init(id: Int(imageInfo.key) ?? 0, url: imageInfo.url)
          }
          return nil
        },
      documentImageUrls: documentImages.items
        .compactMap { item -> LedgerDetail.ImageURL? in
          if case .image(let imageInfo) = item {
            return .init(id: Int(imageInfo.key) ?? 0, url: imageInfo.url)
          }
          return nil
        },
      authorName: authorName
    )
  }
}

/// Empty
extension LedgerDetailItem {
  private init() {
    self.id = 0
    self.storeInfo = ""
    self.amount = "0"
    self.fundType = .expense
    self.memo = ""
    self.date = ""
    self.time = ""
    self.receiptImages = .init(
      model: .default("영수증(최대12장)"),
      items: [.description("내용없음")]
    )
    self.documentImages = .init(
      model: .default("증빙자료(최대12장)"),
      items: [.description("내용없음")]
    )
    self.authorName = ""
  }

  static var empty: LedgerDetailItem { .init() }
}

/// 이미지 아이템 추가, 제거 상태 변경 기능
extension LedgerDetailItem {

  /// 이미지 추가 버튼 + 이미지만 남도록 필터링
  /// 기존 이미지가 12장일경우 이미지 추가 x
  mutating func setUpdate() {
    let prevReceiptImageItems = receiptImages.items.filter {
      if case .imageAddButton = $0 { return false }
      if case .description = $0 { return false }
      return true
    }

    if prevReceiptImageItems.count == 12 {
      receiptImages.items = prevReceiptImageItems
    } else {
      receiptImages.items = [.imageAddButton] + prevReceiptImageItems
    }

    let prevDocumentImageItems = documentImages.items.filter {
      if case .imageAddButton = $0 { return false }
      if case .description = $0 { return false }
      return true
    }

    if prevDocumentImageItems.count == 12 {
      documentImages.items = prevDocumentImageItems
    } else {
      documentImages.items = [.imageAddButton] + prevDocumentImageItems
    }
  }

  /// 이미지만 남도록 필터링
  /// 기존 이미지가 0장일경우 내용없음 Description Item 추가
  mutating func setRead() {
    let prevReceiptImageItems = receiptImages.items.filter {
      if case .imageAddButton = $0 { return false }
      if case .description = $0 { return false }
      return true
    }

    if prevReceiptImageItems.count == 0 {
      receiptImages.items = [.description("내용없음")]
    } else {
      receiptImages.items = prevReceiptImageItems
    }

    let prevDocumentImageItems = documentImages.items.filter {
      if case .imageAddButton = $0 { return false }
      if case .description = $0 { return false }
      return true
    }

    if prevDocumentImageItems.count == 0 {
      documentImages.items = [.description("내용없음")]
    } else {
      documentImages.items = prevDocumentImageItems
    }
  }

  /// 이미지 추가, 추가후 12장일경우 이미지 추가 버튼 제거
  mutating func addImageItem(
    section: LedgerContentsReactor.ImageSection,
    imageInfo: LedgerImageInfo
  ) {
    switch section {
    case .receipt:
      addedReceiptImages += [imageInfo]

      let imageItems = receiptImages.items.filter {
        if case .imageAddButton = $0 { return false }
        if case .description = $0 { return false }
        return true
      }

      if imageItems.count == 11 {
        receiptImages.items = imageItems + [.image(imageInfo)]
      } else {
        receiptImages.items = [.imageAddButton] + imageItems + [.image(imageInfo)]
      }
    case .document:
      addedDocumentImages += [imageInfo]

      let imageItems = documentImages.items.filter {
        if case .imageAddButton = $0 { return false }
        if case .description = $0 { return false }
        return true
      }

      if imageItems.count == 11 {
        documentImages.items = imageItems + [.image(imageInfo)]
      } else {
        documentImages.items = [.imageAddButton] + imageItems + [.image(imageInfo)]
      }
    }
  }

  /// 이미지 제거, 이미지 제거후 12개 미만일경우 + 버튼 추가
  mutating func deleteImageItem(
    section: LedgerContentsReactor.ImageSection,
    imageInfo: LedgerImageInfo
  ) {
    switch section {
    case .receipt:
      let matchedItem = addedReceiptImages.first(where: { $0 == imageInfo })
      if matchedItem != nil {
        addedReceiptImages = addedReceiptImages.filter { $0 != imageInfo }
      } else {
        deletedReceiptImages += [imageInfo]
      }

      let filteredItems = receiptImages.items.filter {
        guard case .image(let info) = $0 else { return false }
        return info.key != imageInfo.key ? true : false
      }

      if receiptImages.items.count == 12 {
        receiptImages.items = [.imageAddButton] + filteredItems
      } else {
        receiptImages.items = filteredItems
      }


    case .document:
      let matchedItem = addedDocumentImages.first(where: { $0 == imageInfo })
      if matchedItem != nil {
        addedDocumentImages = addedDocumentImages.filter { $0 != imageInfo }
      } else {
        deletedDocumentImages += [imageInfo]
      }

      let filteredItems = documentImages.items.filter {
        guard case .image(let info) = $0 else { return false }
        return info.key != imageInfo.key ? true : false
      }

      if documentImages.items.count == 12 {
        documentImages.items = [.imageAddButton] + filteredItems
      } else {
        documentImages.items = filteredItems
      }
    }
  }
}

extension LedgerDetailItem: Equatable {
  static func == (lhs: LedgerDetailItem, rhs: LedgerDetailItem) -> Bool {
    let lhsReceiptUrls: [String] = lhs.receiptImages.items
      .compactMap { item -> String? in
        if case .image(let imageInfo) = item {
          return imageInfo.url
        }
        return nil
      }

    let rhsReceiptUrls: [String] = rhs.receiptImages.items
      .compactMap { item -> String? in
        if case .image(let imageInfo) = item {
          return imageInfo.url
        }
        return nil
      }

    let lhsDocumentUrls: [String] = lhs.documentImages.items
      .compactMap { item -> String? in
        if case .image(let imageInfo) = item {
          return imageInfo.url
        }
        return nil
      }

    let rhsDocumentUrls: [String] = rhs.documentImages.items
      .compactMap { item -> String? in
        if case .image(let imageInfo) = item {
          return imageInfo.url
        }
        return nil
      }

    if lhs.id == rhs.id 
        && lhs.storeInfo == rhs.storeInfo
        && lhs.amount == rhs.amount
        && lhs.fundType == rhs.fundType 
        && lhs.date == rhs.date
        && lhs.time == rhs.time
        && lhs.memo == rhs.memo
        && lhsReceiptUrls == rhsDocumentUrls
        && lhsDocumentUrls == rhsDocumentUrls {
      return true
    }
    return false
  }
}
