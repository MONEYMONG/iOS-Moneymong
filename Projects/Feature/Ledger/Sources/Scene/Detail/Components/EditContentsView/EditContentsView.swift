import UIKit

import DesignSystem
import NetworkService

final class EditContentsView: UIView {
  private let rootContainer = UIView()

  private let storeInfoTextField: MMTextField = {
    let v = MMTextField(charactorLimitCount: 20, title: Const.storeInfoTitle)
    v.setPlaceholder(to: Const.storeInfoPlaceholder)
    v.setRequireMark()
    return v
  }()

  private let amountTextField: MMTextField = {
    let v = MMTextField()
    v.setPlaceholder(to: "거래 금액을 입력해주세요")
    v.setRequireMark()
    v.setKeyboardType(to: .numberPad)
    return v
  }()

  private let dateTextField: MMTextField = {
    let v = MMTextField(title: Const.paymentDateTitle)
    v.setPlaceholder(to: "YYYY/MM/DD")
    v.setRequireMark()
    v.setKeyboardType(to: .numberPad)
    return v
  }()

  private let timeTextField: MMTextField = {
    let v = MMTextField(title: Const.paymentTimeTitle)
    v.setPlaceholder(to: "00:00:00(24시 단위)")
    v.setRequireMark()
    v.setKeyboardType(to: .numberPad)
    return v
  }()

  private let memoTextView: MMTextView = {
    let v = MMTextView(charactorLimitCount: 300, title: Const.memoTitle)
    v.setPlaceholder(to: "메모할 내용을 입력하세요")
    return v
  }()

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
            flex.addItem(storeInfoTextField).marginVertical(20)
            flex.addItem(LineDashDivider()).height(1)
            flex.addItem(amountTextField).marginTop(20).marginBottom(2)
            flex.addItem(LineDashDivider()).height(1)
            flex.addItem(dateTextField).marginTop(20).marginBottom(2)
            flex.addItem(LineDashDivider()).height(1)
            flex.addItem(timeTextField).marginTop(20).marginBottom(2)
            flex.addItem(LineDashDivider()).height(1)
            flex.addItem(memoTextView).marginVertical(20)
            flex.addItem(LineDashDivider()).height(1)
//            flex.addItem(receiptImagesView).marginTop(28).marginBottom(20)
//            flex.addItem(LineDashDivider()).height(1)
//            flex.addItem(documentImagesView).marginTop(28).marginBottom(20)
            flex.addItem(LineDashDivider()).height(1)
            flex.addItem(authorNameView).marginVertical(20)
          }
      }
  }

  func configure(ledger: LedgerDetailItem) {
    storeInfoTextField.setText(to: ledger.storeInfo)
    storeInfoTextField.textField.becomeFirstResponder()

    amountTextField.setText(to: ledger.amountText)
    amountTextField.setTitle(
      to: ledger.fundType == .expense 
      ? Const.expenseTitle
      : Const.incomeTitle
    )

    dateTextField.setText(to: ledger.paymentDate)
    timeTextField.setText(to: ledger.paymentTime)
    memoTextView.setText(to: ledger.memo)

    authorNameView.configure(
      title: Const.authorNameTitle,
      description: ledger.authorName
    )

    storeInfoTextField.flex.markDirty()
    amountTextField.flex.markDirty()
    dateTextField.flex.markDirty()
    timeTextField.flex.markDirty()
    memoTextView.flex.markDirty()
//    receiptImagesView.flex.markDirty()
//    documentImagesView.flex.markDirty()
    authorNameView.flex.markDirty()
    setNeedsLayout()
  }
}

fileprivate enum Const {
  static var storeInfoTitle: String { "수입·지출 출처" }
  static var storeInfoPlaceholder: String { "점포명을 입력해주세요" }
  static var expenseTitle: String { "지출 금액" }
  static var incomeTitle: String { "수입 금액" }
  static var paymentDateTitle: String { "날짜" }
  static var paymentTimeTitle: String { "시간" }
  static var memoTitle: String { "메모" }
  static var receiptImagesTitle: String { "영수증" }
  static var documentImagesTitle: String { "증빙자료 (최대12장)" }
  static var authorNameTitle: String { "작성자" }
}
