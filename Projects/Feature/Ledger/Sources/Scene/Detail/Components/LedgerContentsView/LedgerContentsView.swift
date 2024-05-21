import UIKit

import BaseFeature
import DesignSystem

import ReactorKit

final class LedgerContentsView: BaseV, View {

  public enum `Type` {
    case create
    case read
    case update
  }

  var disposeBag = DisposeBag()
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.showsVerticalScrollIndicator = false
    scrollView.bounces = false
    scrollView.keyboardDismissMode = .interactive
    return scrollView
  }()

  private let contentsView = UIView()

  private let storeInfoTextField: MMTextField = {
    let v = MMTextField(charactorLimitCount: 20, title: Const.storeInfoTitle)
    v.setPlaceholder(to: Const.storeInfoPlaceholder)
    v.setRequireMark()
    return v
  }()

  private let amountTextField: MMTextField = {
    let v = MMTextField()
    v.setPlaceholder(to: Const.amountPlaceholder)
    v.setRequireMark()
    v.setKeyboardType(to: .numberPad)
    return v
  }()

  private let dateTextField: MMTextField = {
    let v = MMTextField(title: Const.paymentDateTitle)
    v.setPlaceholder(to: Const.paymentDatePlaceholder)
    v.setRequireMark()
    v.setKeyboardType(to: .numberPad)
    return v
  }()

  private let timeTextField: MMTextField = {
    let v = MMTextField(title: Const.paymentTimeTitle)
    v.setPlaceholder(to: Const.paymentTimePlaceholder)
    v.setRequireMark()
    v.setKeyboardType(to: .numberPad)
    return v
  }()

  private let memoTextView: MMTextView = {
    let v = MMTextView(charactorLimitCount: 300, title: Const.memoTitle)
    v.setPlaceholder(to: Const.memoPlaceholder)
    return v
  }()

  private let memoTextField: MMTextField = {
    let v = MMTextField(title: Const.memoTitle)
    v.setIsEnabled(to: true)
    return v
  }()

  private let authorNameTextField = MMTextField(title: Const.authorNameTitle)

  private var type: `Type` {
    didSet { updateState() }
  }

  init(type: `Type`) {
    self.type = type
    super.init()
    updateState()
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    scrollView.contentSize = CGSize(
      width: contentsView.frame.width,
      height: contentsView.frame.height + 28
    )
  }

  override func setupUI() {
    super.setupUI()
    backgroundColor = .clear
  }

  func bind(reactor: LedgerContentsReactor) {
  }

  private func setupCreateConstraint() {

  }

  private func setupRead() {
    rootContainer.flex.define { flex in
      flex.addItem(scrollView)
        .shrink(1)
        .paddingHorizontal(20)
        .define { flex in
          flex.addItem(contentsView)
            .backgroundColor(Colors.White._1)
            .cornerRadius(16)
            .border(1, Colors.Blue._3)
            .padding(8, 16)
            .define { flex in
              flex.addItem(storeInfoTextField).marginVertical(20)
              flex.addItem(LineDashDivider()).height(1)
              flex.addItem(amountTextField).marginVertical(20)
              flex.addItem(LineDashDivider()).height(1)
              flex.addItem(dateTextField).marginVertical(20)
              flex.addItem(LineDashDivider()).height(1)
              flex.addItem(timeTextField).marginVertical(20)
              flex.addItem(LineDashDivider()).height(1)
              flex.addItem(memoTextField).marginVertical(20)
              //         flex.addItem(LineDashDivider()).height(1)
              //         flex.addItem(receiptImagesView).marginTop(28).marginBottom(20)
              //         flex.addItem(LineDashDivider()).height(1)
              //         flex.addItem(documentImagesView).marginTop(28).marginBottom(20)
              flex.addItem(LineDashDivider()).height(1)
              flex.addItem(authorNameTextField).marginVertical(20)
            }

          flex.addItem().height(28)
        }
    }

    storeInfoTextField.setIsEnabled(to: false)
    storeInfoTextField.setRequireMark(to: false)
    amountTextField.setIsEnabled(to: false)
    amountTextField.setRequireMark(to: false)
    dateTextField.setIsEnabled(to: false)
    dateTextField.setRequireMark(to: false)
    timeTextField.setIsEnabled(to: false)
    timeTextField.setRequireMark(to: false)
    memoTextField.setIsEnabled(to: false)
    memoTextField.setRequireMark(to: false)
    authorNameTextField.setIsEnabled(to: false)
    authorNameTextField.setRequireMark(to: false)
  }

  private func setupUpdateConstraint() {

  }

  // func setConstraints() {
  //  rootContainer.flex
  //   .backgroundColor(Colors.White._1)
  //   .cornerRadius(16)
  //   .border(1, Colors.Blue._3)
  //   .define { flex in
  //    flex.addItem()
  //     .padding(8, 16)
  //     .define { flex in
  //      flex.addItem(storeInfoView).marginVertical(20)
  //      flex.addItem(LineDashDivider()).height(1)
  //      flex.addItem(fundAmountView).marginVertical(20)
  //      flex.addItem(LineDashDivider()).height(1)
  //      flex.addItem(paymentDateView).marginVertical(20)
  //      flex.addItem(LineDashDivider()).height(1)
  //      flex.addItem(paymentTimeView).marginVertical(20)
  //      flex.addItem(LineDashDivider()).height(1)
  //      flex.addItem(memoView).marginVertical(20)
  //      flex.addItem(LineDashDivider()).height(1)
  //      flex.addItem(receiptImagesView).marginTop(28).marginBottom(20)
  //      flex.addItem(LineDashDivider()).height(1)
  //      flex.addItem(documentImagesView).marginTop(28).marginBottom(20)
  //      flex.addItem(LineDashDivider()).height(1)
  //      flex.addItem(authorNameView).marginVertical(20)
  //     }
  //   }
  // }
  // func configure(ledger: LedgerDetailItem) {
  //  storeInfoView.configure(
  //   title: Const.storeInfoTitle,
  //   description: ledger.storeInfo
  //  )
  //  fundAmountView.configure(
  //   title: ledger.fundType == .expense ? Const.expenseTitle : Const.incomeTitle,
  //   description: ledger.amountText
  //  )
  //  paymentDateView.configure(
  //   title: Const.paymentDateTitle,
  //   description: ledger.paymentDate
  //  )
  //  paymentTimeView.configure(
  //   title: Const.paymentTimeTitle,
  //   description: ledger.paymentTime
  //  )
  //  memoView.configure(
  //   title: Const.memoTitle,
  //   description: ledger.memo
  //  )
  //  receiptImagesView.configure(
  //   title: Const.receiptImagesTitle,
  //   images: ledger.receiptImageUrls
  //  )
  //  documentImagesView.configure(
  //   title: Const.documentImagesTitle,
  //   images: ledger.documentImageUrls
  //  )
  //  authorNameView.configure(
  //   title: Const.authorNameTitle,
  //   description: ledger.authorName
  //  )
  //
  //  storeInfoView.flex.markDirty()
  //  fundAmountView.flex.markDirty()
  //  paymentDateView.flex.markDirty()
  //  paymentTimeView.flex.markDirty()
  //  memoView.flex.markDirty()
  //  receiptImagesView.flex.markDirty()
  //  documentImagesView.flex.markDirty()
  //  authorNameView.flex.markDirty()
  //  setNeedsLayout()
  // }

  private func updateState() {
    switch type {
    case .create:
      setupCreateConstraint()
    case .read:
      setupRead()
    case .update:
      setupUpdateConstraint()
    }
  }
}

extension LedgerContentsView {
  func setType(_ type: `Type`) {
    self.type = type
  }
}

fileprivate enum Const {
  static var storeInfoTitle: String { "수입·지출 출처" }
  static var storeInfoPlaceholder: String { "점포명을 입력해주세요" }
  static var expenseTitle: String { "지출 금액" }
  static var incomeTitle: String { "수입 금액" }
  static var amountPlaceholder: String { "거래 금액을 입력해주세요" }
  static var paymentDateTitle: String { "날짜" }
  static var paymentDatePlaceholder: String { "YYYY/MM/DD" }
  static var paymentTimeTitle: String { "시간" }
  static var paymentTimePlaceholder: String { "00:00:00(24시 단위)" }
  static var memoTitle: String { "메모" }
  static var memoPlaceholder: String { "메모할 내용을 입력하세요" }
  static var receiptImagesTitle: String { "영수증" }
  static var documentImagesTitle: String { "증빙자료 (최대12장)" }
  static var authorNameTitle: String { "작성자" }
}
