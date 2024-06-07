import UIKit

import BaseFeature
import DesignSystem
import Utility
import NetworkService

import ReactorKit
import RxDataSources

final class LedgerContentsView: BaseView, View, UIScrollViewDelegate {

  public enum State {
    case read
    case update
  }

  struct ViewHeight {
    static var keyboardHeight: Double = 0
    static var verticalMargin: Double = 40
  }

  weak var coordinator: LedgerCoordinator?

  var disposeBag = DisposeBag()

  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.showsVerticalScrollIndicator = false
    scrollView.bounces = false
    scrollView.keyboardDismissMode = .interactive
    return scrollView
  }()

  private let contentsView = UIView()

  private let keyboardSpaceView = UIView()

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
    v.setError(message: "999,999,999원 이내로 입력해주세요") { text in
      guard let value = Int(text.replacingOccurrences(of: ",", with: "")) else {
        return false
      }

      return value <= 999_999_999
    }
    return v
  }()

  private let dateTextField: MMTextField = {
    let v = MMTextField(title: Const.paymentDateTitle)
    v.setPlaceholder(to: Const.paymentDatePlaceholder)
    v.setRequireMark()
    v.setKeyboardType(to: .numberPad)
    v.setError(message: "올바른 날짜를 입력해 주세요") { text in
      let pattern = "^\\d{4}.(0[1-9]|1[012]).(0[1-9]|[12]\\d|3[01])$"
      let regex = try! NSRegularExpression(pattern: pattern)

      return regex.firstMatch(in: text, range: NSRange(location: 0, length: text.count)) != nil
    }
    return v
  }()

  private let timeTextField: MMTextField = {
    let v = MMTextField(title: Const.paymentTimeTitle)
    v.setPlaceholder(to: Const.paymentTimePlaceholder)
    v.setRequireMark()
    v.setKeyboardType(to: .numberPad)
    v.setError(message: "올바른 시간을 입력해 주세요") { text in
      let pattern = "^([01]?[0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$"
      let regex = try! NSRegularExpression(pattern: pattern)

      return regex.firstMatch(in: text, range: NSRange(location: 0, length: text.count)) != nil
    }
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

  lazy var receiptCollectionView: LedgerContentsCollectionView = {
    let v = LedgerContentsCollectionView()
    v.reactor = reactor
    return v
  }()

  lazy var documentCollentionView: LedgerContentsCollectionView = {
    let v = LedgerContentsCollectionView()
    v.reactor = reactor
    return v
  }()

  private let authorNameTextField = MMTextField(title: Const.authorNameTitle)

  private var isShowKeyboard: Bool = false

  init(coordinator: LedgerCoordinator, reactor: LedgerContentsReactor) {
    super.init()
    self.coordinator = coordinator
    self.reactor = reactor
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    var contentsViewHeight = contentsView.frame.height + ViewHeight.verticalMargin
    if isShowKeyboard { contentsViewHeight += ViewHeight.keyboardHeight }
    scrollView.contentSize.height = contentsViewHeight
  }

  override func setupUI() {
    super.setupUI()
    backgroundColor = .clear
  }

  func bind(reactor: LedgerContentsReactor) {
    bindState(reactor: reactor)
    bindAction(reactor: reactor)
  }

  func bindState(reactor: LedgerContentsReactor) {
    reactor.pulse(\.$currentLedgerItem)
      .distinctUntilChanged()
      .map { $0.fundType }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, fundType in
        owner.amountTextField.setTitle(
          to: fundType == .expense
          ? Const.expenseTitle
          : Const.incomeTitle
        )
      }
      .disposed(by: disposeBag)

    reactor.pulse(\.$currentLedgerItem)
      .distinctUntilChanged()
      .map { $0.storeInfo }
      .bind(to: storeInfoTextField.textField.rx.text)
      .disposed(by: disposeBag)

    reactor.pulse(\.$currentLedgerItem)
      .distinctUntilChanged()
      .map { $0.amount }
      .bind(to: amountTextField.textField.rx.text)
      .disposed(by: disposeBag)

    reactor.pulse(\.$currentLedgerItem)
      .distinctUntilChanged()
      .map { $0.date }
      .bind(to: dateTextField.textField.rx.text)
      .disposed(by: disposeBag)

    reactor.pulse(\.$currentLedgerItem)
      .distinctUntilChanged()
      .map { $0.time }
      .bind(to: timeTextField.textField.rx.text)
      .disposed(by: disposeBag)

    reactor.pulse(\.$currentLedgerItem)
      .distinctUntilChanged()
      .map { $0.memo }
      .map { $0.isEmpty ? Const.emptyDescription : $0 }
      .bind(to: memoTextField.textField.rx.text)
      .disposed(by: disposeBag)

    reactor.pulse(\.$currentLedgerItem)
      .distinctUntilChanged()
      .map { $0.memo }
      .observe(on: MainScheduler.instance)
      .bind(with: self, onNext: { owner, value in
        owner.memoTextView.setText(to: value)
      })
      .disposed(by: disposeBag)

    reactor.pulse(\.$currentLedgerItem)
      .map { [$0.receiptImages] }
      .distinctUntilChanged()
      .bind(to: receiptCollectionView.rx.items(dataSource: receiptCollectionView.dataSources))
      .disposed(by: disposeBag)

    reactor.pulse(\.$currentLedgerItem)
      .map { $0.receiptImages }
      .distinctUntilChanged()
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, items in
        owner.receiptCollectionView.updateCollectionHeigh(items: items)
        owner.setNeedsLayout()
      }
      .disposed(by: disposeBag)

    reactor.pulse(\.$currentLedgerItem)
      .map { [$0.documentImages] }
      .distinctUntilChanged()
      .bind(to: documentCollentionView.rx.items(dataSource: documentCollentionView.dataSources))
      .disposed(by: disposeBag)

    reactor.pulse(\.$currentLedgerItem)
      .map { $0.documentImages }
      .distinctUntilChanged()
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, items in
        owner.documentCollentionView.updateCollectionHeigh(items: items)
        owner.setNeedsLayout()
      }
      .disposed(by: disposeBag)

    reactor.pulse(\.$currentLedgerItem)
      .distinctUntilChanged()
      .map { $0.authorName }
      .bind(to: authorNameTextField.textField.rx.text)
      .disposed(by: disposeBag)

    reactor.pulse(\.$selectedSection)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, _ in
        owner.coordinator?.present(.imagePicker(delegate: owner))
      }
      .disposed(by: disposeBag)

    reactor.pulse(\.$error)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, error in
        owner.coordinator?.present(
          .alert(title: error.localizedDescription, subTitle: nil, type: .onlyOkButton({}))
        )
      }
      .disposed(by: disposeBag)

    reactor.pulse(\.$state)
      .compactMap { $0 }
      .distinctUntilChanged()
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, state in
        switch state {
        case .update: owner.setupUpdate()
        case .read: owner.setupRead()
        }
      }
      .disposed(by: disposeBag)
  }

  private func bindAction(reactor: LedgerContentsReactor) {
    rx.tapGesture
      .bind(with: self) { owner, _ in
        owner.endEditing(true)
      }
      .disposed(by: disposeBag)

    rx.swipeRightGesture
      .map { _ in reactor.currentState.state }
      .bind(with: self) { owner, state in
        guard state == .read else { return }
        owner.coordinator?.pop()
      }
      .disposed(by: disposeBag)

    NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
      .bind(with: self) { owner, noti in
        guard let keyboardFrame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
          return
        }
        owner.isShowKeyboard = true
        ViewHeight.keyboardHeight = keyboardFrame.cgRectValue.height - 120
        owner.keyboardSpaceView.flex
          .height(keyboardFrame.cgRectValue.height - 120)
          .markDirty()
        owner.setNeedsLayout()
      }
      .disposed(by: disposeBag)

    NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
      .bind(with: self) { owner, _ in
        owner.isShowKeyboard = false
        ViewHeight.keyboardHeight = 0
        owner.keyboardSpaceView.flex.height(0).markDirty()
      }
      .disposed(by: disposeBag)

    storeInfoTextField.textField.rx.text
      .distinctUntilChanged()
      .compactMap { $0 }
      .map { Reactor.Action.didValueChanged(.storeInfo($0)) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    storeInfoTextField.clearButton.rx.tap
      .map { Reactor.Action.didValueChanged(.storeInfo(Const.emptyString)) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    amountTextField.textField.rx.text
      .distinctUntilChanged()
      .compactMap { $0 }
      .map { Reactor.Action.didValueChanged(.amount($0)) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    amountTextField.clearButton.rx.tap
      .map { Reactor.Action.didValueChanged(.amount(Const.emptyString)) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    dateTextField.textField.rx.text
      .distinctUntilChanged()
      .compactMap { $0 }
      .map { Reactor.Action.didValueChanged(.date($0)) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    dateTextField.clearButton.rx.tap
      .map { Reactor.Action.didValueChanged(.date(Const.emptyString)) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    timeTextField.textField.rx.text
      .distinctUntilChanged()
      .compactMap { $0 }
      .map { Reactor.Action.didValueChanged(.time($0)) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    timeTextField.clearButton.rx.tap
      .map { Reactor.Action.didValueChanged(.time(Const.emptyString)) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    memoTextView.textView.rx.text
      .distinctUntilChanged()
      .compactMap { $0 }
      .bind(with: self) { owner, value in
        owner.memoTextField.setText(to: value.isEmpty ? Const.emptyDescription : value)
        reactor.action.onNext(.didValueChanged(.memo(value)))
        owner.setNeedsLayout()
      }
      .disposed(by: disposeBag)

    authorNameTextField.textField.rx.text
      .distinctUntilChanged()
      .compactMap { $0 }
      .map { Reactor.Action.didValueChanged(.authorName($0)) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    authorNameTextField.clearButton.rx.tap
      .map { Reactor.Action.didValueChanged(.authorName(Const.emptyString)) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    receiptCollectionView.rx.modelSelected(LedgerImageSectionModel.Item.self)
      .filter { $0 == .imageAddButton }
      .map { _ in Reactor.Action.selectedImageSection(.receipt) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    documentCollentionView.rx.modelSelected(LedgerImageSectionModel.Item.self)
      .filter { $0 == .imageAddButton }
      .map { _ in Reactor.Action.selectedImageSection(.document) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  private func setupRead() {
    contentsView.removeAllSubViews()

    rootContainer.flex.define { flex in
      flex.addItem(scrollView)
        .shrink(1)
        .paddingHorizontal(20)
        .paddingBottom(28)
        .define { flex in
          flex.addItem(contentsView)
            .marginTop(12)
            .marginBottom(28)
            .backgroundColor(Colors.White._1)
            .cornerRadius(16)
            .border(1, Colors.Blue._3)
            .paddingVertical(8)
            .define { flex in
              flex.addItem(storeInfoTextField)
                .marginTop(20)
                .marginBottom(2)
                .marginHorizontal(16)

              flex.addItem(LineDashDivider())
                .height(1)
                .marginHorizontal(16)

              flex.addItem(amountTextField)
                .marginTop(20)
                .marginBottom(2)
                .marginHorizontal(16)

              flex.addItem(LineDashDivider())
                .height(1)
                .marginHorizontal(16)

              flex.addItem(dateTextField)
                .marginTop(20)
                .marginBottom(2)
                .marginHorizontal(16)

              flex.addItem(LineDashDivider())
                .height(1)
                .marginHorizontal(16)

              flex.addItem(timeTextField)
                .marginTop(20)
                .marginBottom(2)
                .marginHorizontal(16)

              flex.addItem(LineDashDivider())
                .height(1)
                .marginHorizontal(16)

              flex.addItem(memoTextField)
                .marginTop(20)
                .marginBottom(2)
                .marginHorizontal(16)

              flex.addItem(LineDashDivider())
                .height(1)
                .marginHorizontal(16)

              flex.addItem(receiptCollectionView)
                .marginVertical(20)

              flex.addItem(LineDashDivider())
                .height(1)
                .marginHorizontal(16)

              flex.addItem(documentCollentionView)
                .marginVertical(20)

              flex.addItem(LineDashDivider())
                .height(1)
                .marginHorizontal(16)

              flex.addItem(authorNameTextField)
                .marginTop(20)
                .marginBottom(2)
                .marginHorizontal(16)
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
    memoTextView.flex.display(.none).markDirty()
    memoTextField.isHidden = false
    memoTextField.flex.display(.flex).markDirty()

    setNeedsLayout()
  }

  private func setupUpdate() {
    contentsView.removeAllSubViews()
    scrollView.removeAllSubViews()
    rootContainer.removeAllSubViews()

    rootContainer.flex.define { flex in
      flex.addItem(scrollView)
        .shrink(1)
        .paddingHorizontal(20)
        .define { flex in
          flex.addItem(contentsView)
            .backgroundColor(Colors.White._1)
            .cornerRadius(16)
            .border(1, Colors.Blue._3)
            .paddingVertical(8)
            .define { flex in
              flex.addItem(storeInfoTextField).margin(20, 16)
              flex.addItem(LineDashDivider()).height(1).marginHorizontal(16)
              flex.addItem(amountTextField).margin(20, 16)
              flex.addItem(LineDashDivider()).height(1).marginHorizontal(16)
              flex.addItem(dateTextField).margin(20, 16)
              flex.addItem(LineDashDivider()).height(1).marginHorizontal(16)
              flex.addItem(timeTextField).margin(20, 16)
              flex.addItem(LineDashDivider()).height(1).marginHorizontal(16)
              flex.addItem(memoTextView).margin(20, 16)
              flex.addItem(LineDashDivider()).height(1).marginHorizontal(16)
              flex.addItem(receiptCollectionView).marginVertical(20)
              flex.addItem(LineDashDivider()).height(1).marginHorizontal(16)
              flex.addItem(documentCollentionView).marginVertical(20)
              flex.addItem(LineDashDivider()).height(1).marginHorizontal(16)
              flex.addItem(authorNameTextField).margin(20, 16)
            }
          flex.addItem(keyboardSpaceView).backgroundColor(.clear)
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
    memoTextField.flex.display(.none).markDirty()
    memoTextView.isHidden = false
    memoTextView.flex.display(.flex).markDirty()
    scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    storeInfoTextField.textField.becomeFirstResponder()

    setNeedsLayout()
  }
}

/// ImagePicker
extension LedgerContentsView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
  ) {
    Task {
      guard let image = info[.originalImage] as? UIImage else { return }
      let scale = (receiptCollectionView.frame.width * 0.28) / image.size.width
      guard let data = image.jpegData(compressionQuality: scale) else { return }
      reactor?.action.onNext(.selectedImage(data))
    }
    picker.dismiss(animated: true, completion: nil)
  }
}

fileprivate extension UIView {
  func removeAllSubViews() {
    self.subviews.forEach { $0.removeFromSuperview() }
  }
}

fileprivate enum Const {
  static var emptyString: String { "" }
  static var emptyDescription: String { "내용없음" }
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
