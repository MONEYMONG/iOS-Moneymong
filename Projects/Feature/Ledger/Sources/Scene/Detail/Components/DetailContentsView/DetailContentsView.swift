import UIKit

import DesignSystem
import NetworkService

final class DetailContentsView: UIView {
  private let rootContainer = UIView()
  private let storeInfoView = TitleDescriptionView()
  private let fundAmountView = TitleDescriptionView()
  private let paymentDateView = TitleDescriptionView()
  private let paymentTimeView = TitleDescriptionView()
  private let memoView = TitleDescriptionView()
  private let receiptImagesView = TitleImageView()
  private let documentImagesView = TitleImageView()
  private let authorNameView = TitleDescriptionView()

  init() {
    super.init(frame: .zero)
    setConstraints()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }

  func setConstraints() {
    addSubview(rootContainer)
    rootContainer.flex
      .backgroundColor(Colors.White._1)
      .cornerRadius(16)
      .border(1, Colors.Blue._3)
      .define { flex in
        flex.addItem()
          .padding(8, 16)
          .define { flex in
            flex.addItem(storeInfoView).marginVertical(20)
            flex.addItem(LineDashDivider()).height(1)
            flex.addItem(fundAmountView).marginVertical(20)
            flex.addItem(LineDashDivider()).height(1)
            flex.addItem(paymentDateView).marginVertical(20)
            flex.addItem(LineDashDivider()).height(1)
            flex.addItem(paymentTimeView).marginVertical(20)
            flex.addItem(LineDashDivider()).height(1)
            flex.addItem(memoView).marginVertical(20)
            flex.addItem(LineDashDivider()).height(1)
            flex.addItem(receiptImagesView).marginTop(28).marginBottom(20)
            flex.addItem(LineDashDivider()).height(1)
            flex.addItem(documentImagesView).marginTop(28).marginBottom(20)
            flex.addItem(LineDashDivider()).height(1)
            flex.addItem(authorNameView).marginVertical(20)
          }
      }
  }

  func configure(ledger: LedgerDetailItem) {
    storeInfoView.configure(
      title: Const.storeInfoTitle,
      description: ledger.storeInfo
    )
    fundAmountView.configure(
      title: ledger.fundType == .expense ? Const.expenseTitle : Const.incomeTitle,
      description: ledger.amountText
    )
    paymentDateView.configure(
      title: Const.paymentDateTitle,
      description: ledger.paymentDate
    )
    paymentTimeView.configure(
      title: Const.paymentTimeTitle,
      description: ledger.paymentTime
    )
    memoView.configure(
      title: Const.memoTitle,
      description: ledger.memo
    )
    receiptImagesView.configure(
      title: Const.receiptImagesTitle,
      images: ledger.receiptImageUrls
    )
    documentImagesView.configure(
      title: Const.documentImagesTitle,
      images: ledger.documentImageUrls
    )
    authorNameView.configure(
      title: Const.authorNameTitle,
      description: ledger.authorName
    )

    storeInfoView.flex.markDirty()
    fundAmountView.flex.markDirty()
    paymentDateView.flex.markDirty()
    paymentTimeView.flex.markDirty()
    memoView.flex.markDirty()
    receiptImagesView.flex.markDirty()
    documentImagesView.flex.markDirty()
    authorNameView.flex.markDirty()
    setNeedsLayout()
  }
}

fileprivate enum Const {
  static var storeInfoTitle: String { "수입·지출 출처" }
  static var expenseTitle: String { "지출 금액" }
  static var incomeTitle: String { "수입 금액" }
  static var paymentDateTitle: String { "날짜" }
  static var paymentTimeTitle: String { "시간" }
  static var memoTitle: String { "메모" }
  static var receiptImagesTitle: String { "영수증" }
  static var documentImagesTitle: String { "증빙자료 (최대12장)" }
  static var authorNameTitle: String { "작성자" }
}
