import UIKit

import BaseFeature
import DesignSystem

import ReactorKit
import RxDataSources

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

  private lazy var receiptCollectionView: LedgerContensImageCollentionView = {
    let v = LedgerContensImageCollentionView()
    v.registerHeader(DefaultSectionHeader.self)
    // cell, header 등록
    return v
  }()

  private lazy var documentCollentionView: LedgerContensImageCollentionView = {
    let v = LedgerContensImageCollentionView()
    return v
  }()

  private let dataSource = RxCollectionViewSectionedReloadDataSource<ImageSectionModel.Model>(
    configureCell: { dataSource, collectionView, indexPath, item in
      switch item {
      case .button:
        return collectionView.dequeueCell(AddImageCell.self, for: indexPath)
      case .image(_, _):
        return collectionView.dequeueCell(ImageCell.self, for: indexPath).configure(with: item)
      }
    },
    configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
      let section = dataSource[indexPath.section]
      if section.model == .receipt {
        let section = collectionView.dequeueHeader(ReceiptHeader.self, for: indexPath)
        return section
      } else {
        let section = collectionView.dequeueHeader(DocumentHeader.self, for: indexPath)
        return section
      }
    }
  )

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

//    scrollView.contentSize = CGSize(
//      width: contentsView.frame.width,
//      height: contentsView.frame.height + 28
//    )

    scrollView.contentSize = contentsView.frame.size
  }

  override func setupUI() {
    super.setupUI()
    backgroundColor = .clear
  }

  func bind(reactor: LedgerContentsReactor) {
    reactor.pulse(\.$fundType)
      .compactMap { $0 }
      .bind(with: self) { owner, fundType in
        owner.amountTextField.setTitle(
          to: fundType == .expense
          ? Const.expenseTitle
          : Const.incomeTitle
        )
      }
      .disposed(by: disposeBag)

    reactor.pulse(\.$storeInfo)
      .compactMap { $0 }
      .bind(to: storeInfoTextField.textField.rx.text)
      .disposed(by: disposeBag)

    reactor.pulse(\.$amount)
      .compactMap { $0 }
      .bind(to: amountTextField.textField.rx.text)
      .disposed(by: disposeBag)

    reactor.pulse(\.$date)
      .compactMap { $0 }
      .bind(to: dateTextField.textField.rx.text)
      .disposed(by: disposeBag)

    reactor.pulse(\.$time)
      .compactMap { $0 }
      .bind(to: timeTextField.textField.rx.text)
      .disposed(by: disposeBag)

    reactor.pulse(\.$memo)
      .compactMap { $0 }
      .bind(with: self, onNext: { owner, memo in
        owner.memoTextField.setText(to: memo)
        owner.memoTextView.setText(to: memo)
      })
      .disposed(by: disposeBag)

//    reactor.pulse(\.$receiptImageUrls)
//      .compactMap { $0 }
//      .bind(to: receiptCollectionView.rx.items) { _, _, _ in
//
//      }
//      .disposed(by: disposeBag)

    reactor.pulse(\.$receiptImageUrls)
      .bind(to: receiptCollectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)

    reactor.pulse(\.$authorName)
      .compactMap { $0 }
      .bind(to: authorNameTextField.textField.rx.text)
      .disposed(by: disposeBag)
  }

  private func setupCreate() {

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
              flex.addItem(storeInfoTextField).marginTop(20).marginBottom(2)
              flex.addItem(LineDashDivider()).height(1)
              flex.addItem(amountTextField).marginTop(20).marginBottom(2)
              flex.addItem(LineDashDivider()).height(1)
              flex.addItem(dateTextField).marginTop(20).marginBottom(2)
              flex.addItem(LineDashDivider()).height(1)
              flex.addItem(timeTextField).marginTop(20).marginBottom(2)
              flex.addItem(LineDashDivider()).height(1)
              flex.addItem(memoTextField).marginTop(20).marginBottom(2)
              flex.addItem(LineDashDivider()).height(1)
              flex.addItem(receiptCollectionView).marginVertical(20)
              flex.addItem(LineDashDivider()).height(1)
              flex.addItem(documentCollentionView).marginVertical(20)
              flex.addItem(LineDashDivider()).height(1)
              flex.addItem(authorNameTextField).marginTop(20).marginBottom(2)
            }
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

    memoTextView.isHidden = true
    memoTextView.flex.isIncludedInLayout(true).markDirty()
    memoTextField.isHidden = false
    memoTextField.flex.isIncludedInLayout(false).markDirty()

    setNeedsLayout()
  }

  private func setupUpdate() {
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
              flex.addItem(memoTextView).marginVertical(20)
              flex.addItem(LineDashDivider()).height(1)
              flex.addItem(receiptCollectionView).marginVertical(20)
              flex.addItem(LineDashDivider()).height(1)
              flex.addItem(documentCollentionView).marginVertical(20)
              flex.addItem(LineDashDivider()).height(1)
              flex.addItem(authorNameTextField).marginVertical(20)
            }
        }
    }

    storeInfoTextField.setIsEnabled(to: true)
    storeInfoTextField.setRequireMark(to: true)
    amountTextField.setIsEnabled(to: true)
    amountTextField.setRequireMark(to: true)
    dateTextField.setIsEnabled(to: true)
    dateTextField.setRequireMark(to: true)
    timeTextField.setIsEnabled(to: true)
    timeTextField.setRequireMark(to: true)
    memoTextField.setIsEnabled(to: true)
    memoTextField.setRequireMark(to: true)
    authorNameTextField.setIsEnabled(to: false)
    authorNameTextField.setRequireMark(to: false)

    memoTextField.isHidden = true
    memoTextField.flex.isIncludedInLayout(true).markDirty()
    memoTextView.isHidden = false
    memoTextView.flex.isIncludedInLayout(false).markDirty()

    scrollView.scrollsToTop = true
    storeInfoTextField.textField.becomeFirstResponder()

    setNeedsLayout()
  }

  private func updateState() {
    switch type {
    case .create:
      setupCreate()
    case .read:
      setupRead()
    case .update:
      setupUpdate()
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
