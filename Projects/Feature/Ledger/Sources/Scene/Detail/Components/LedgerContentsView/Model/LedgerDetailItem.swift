import BaseDomain
import LedgerInterface

/// 화면에 보여주기 위한 용도로 가공한 아이템
struct LedgerDetailItem {
  let id: Int
  var storeInfo: String
  var amount: String
  var fundType: FundType
  var memo: String
  var date: String
  var time: String
  var documentImages: LedgerImageSectionModel.Model
  var addedDocumentImages: [LedgerImageInfo] = []
  var deletedDocumentImages: [LedgerImageInfo] = []
  var authorName: String
  var category: String?

  private let formatter = ContentFormatter()

  init(ledger: LedgerDetail) {
    let (date, time) = formatter.splitToDateTime(with: ledger.paymentDate)

    self.id = ledger.id
    self.storeInfo = ledger.storeInfo
    self.amount = formatter.convertToAmount(with: ledger.amount) ?? "0"
    self.fundType = ledger.fundType
    self.memo = ledger.description
    self.date = date
    self.time = time
    self.documentImages = .init(
      model: .default("사진 첨부 (최대12장)"),
      items: ledger.documentImageUrls.count == 0 ? [.description("내용없음")] : ledger.documentImageUrls.map { return .image(.init(key: "\($0.id)", url: $0.url)) }
    )
    self.authorName = ledger.authorName
    self.category = ledger.category
  }

  var toEntity: LedgerDetail {
    return .init(
      id: id,
      storeInfo: storeInfo,
      amount: Int(amount.filter { $0.isNumber }) ?? 0,
      fundType: fundType,
      description: memo,
      paymentDate: formatter.mergeWithISO8601(date: date, time: time) ?? "",
      documentImageUrls: documentImages.items
        .compactMap { item -> LedgerDetail.ImageURL? in
          if case .image(let imageInfo) = item {
            return .init(id: Int(imageInfo.key) ?? 0, url: imageInfo.url)
          }
          return nil
        },
      authorName: authorName,
      category: category
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
    self.documentImages = .init(
      model: .default("사진 첨부 (최대12장)"),
      items: [.description("내용없음")]
    )
    self.authorName = ""
    self.category = nil
  }

  static var empty: LedgerDetailItem { .init() }
}

/// 이미지 아이템 추가, 제거 상태 변경 기능
extension LedgerDetailItem {

  /// 이미지 추가 버튼 + 이미지만 남도록 필터링
  /// 기존 이미지가 12장일경우 이미지 추가 x
  mutating func setUpdate() {
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
    imageInfo: LedgerImageInfo
  ) {
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

  /// 이미지 제거, 이미지 제거후 12개 미만일경우 + 버튼 추가
  mutating func deleteImageItem(
    imageInfo: LedgerImageInfo
  ) {
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
    documentImages.items = [.imageAddButton] + filteredItems
  }
}

extension LedgerDetailItem: Equatable {
  static func == (lhs: LedgerDetailItem, rhs: LedgerDetailItem) -> Bool {
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
        && lhsDocumentUrls == rhsDocumentUrls {
      return true
    }
    return false
  }
}
