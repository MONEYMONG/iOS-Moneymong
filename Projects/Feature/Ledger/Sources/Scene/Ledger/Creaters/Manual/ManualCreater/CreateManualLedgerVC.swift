import UIKit
import Combine

import BaseFeature
import DesignSystem

import LedgerFeatureInterface

import ReactorKit
import RxDataSources
import PinLayout
import FlexLayout

final class CreateManualLedgerVC: BaseVC, View, ImagePickerPresentable {  
  var coordinator: CreateManualLedgerCoordinator?
  private struct ViewSize {
    static var cell: CGSize {
      let width = UIScreen.main.bounds.width * 0.28
      let height = width * 1.33
      return CGSize(width: width, height: height)
    }
    static var cellSpacing: Double = cell.width * 0.095
    static var receiptHeaderHeight: CGFloat =  31
    static var documentHeaderHeight: CGFloat = 16
    static var collectionBaseHeight: CGFloat = ViewSize.cell.height + 8
  }
  
  var disposeBag = DisposeBag()
  private var cancelBag = Set<AnyCancellable>()
  private var startingType: ManualPresentType = .createManual
  
  private let scrollView: UIScrollView = {
    let v = UIScrollView()
    v.contentInset.bottom = 100
    v.keyboardDismissMode = .interactive
    return v
  }()
  private let content = UIView()
  private let smogView: GradationView = {
    let v = GradationView()
    v.setGradation(
      colors: [
        UIColor.white.withAlphaComponent(0.0).cgColor,
        UIColor.white.cgColor
      ],
      location: [0.0, 0.4]
    )
    return v
  }()
  
  private let completeButton = MMButton(title: "작성하기", type: .primary)
  
  private let sourceTextField: MMTextField = {
    MMTextField(charactorLimitCount: 20, title: "수입·지출 출처")
      .setPlaceholder(to: "점포명을 입력해주세요")
      .setRequireMark()
  }()
  
  private let amountTextField: MMTextField = {
    MMTextField(title: "금액")
      .setPlaceholder(to: "거래 금액을 입력해주세요")
      .setRequireMark()
      .setKeyboardType(to: .numberPad)
      .setError() { text in
        guard let value = Int(text.replacingOccurrences(of: ",", with: "")) else {
          return (false, "금액을 입력해주세요")
        }
        return (value <= 999_999_999, "999,999,999원 이내로 입력해주세요")
      }
  }()
  
  private let selectionLabel: UILabel = {
    let v = UILabel()
    v.textColor = Colors.Gray._6
    let attributedStr = NSMutableAttributedString(string: "거래 유형 *")
    attributedStr.addAttribute(
      .foregroundColor,
      value: Colors.Red._3,
      range: NSRange(location: attributedStr.length - 1, length: 1)
    )
    v.attributedText = attributedStr
    v.font = Fonts.body._2
    return v
  }()
  
  private let fundTypeSelection = MMSegmentControl(
    titles: ["지출", "수입"],
    type: .round
  )
  
  private let dateTextField: MMTextField = {
    MMTextField(title: "날짜")
      .setPlaceholder(to: "YYYY/MM/DD")
      .setRequireMark()
      .setKeyboardType(to: .numberPad)
  }()
  
  private let timeTextField: MMTextField = {
    MMTextField(title: "시간")
      .setPlaceholder(to: "00:00:00(24시 단위)")
      .setRequireMark(to: false)
      .setKeyboardType(to: .numberPad)
      .setError() { text in
        if text.isEmpty { return (true, nil) }
        let pattern = "^([01]?[0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$"
        let regex = try! NSRegularExpression(pattern: pattern)
        
        return (regex.firstMatch(in: text, range: NSRange(location: 0, length: text.count)) != nil, "올바른 시간을 입력해 주세요")
      }
  }()
  
  private let writerTitleLabel: UILabel = {
    let v = UILabel()
    v.textColor = Colors.Gray._6
    v.font = Fonts.body._2
    v.setTextWithLineHeight(text: "작성자", lineHeight: 18)
    return v
  }()
  
  private let writerNameLabel: UILabel = {
    let v = UILabel()
    v.textColor = Colors.Gray._10
    v.font = Fonts.body._3
    v.setTextWithLineHeight(text: "머니몽", lineHeight: 20)
    return v
  }()
  
  private lazy var documentCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = ViewSize.cell
    layout.minimumLineSpacing = ViewSize.cellSpacing
    layout.minimumInteritemSpacing = ViewSize.cellSpacing
    layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 8)
    let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
    v.register(AddImageCell.self)
    v.register(ImageCell.self)
    v.isScrollEnabled = false
    v.tag = 1
    return v
  }()
  
  private let memoTextView: MMTextView = {
    MMTextView(charactorLimitCount: 300, title: "메모")
      .setPlaceholder(to: "메모할 내용을 입력하세요")
  }()
  
  private let categoryEditButton: UIButton = {
    let v = UIButton()
    let attributedString = NSAttributedString(
      string: "수정",
      attributes: [
        .font: Fonts.body._2,
        .foregroundColor: Colors.Blue._4
      ]
    )
    v.setAttributedTitle(attributedString, for: .normal)
    return v
  }()
  
  private let chipListView: ChipListView = ChipListView()

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    completeButton.pin.height(56).bottom(view.safeAreaInsets.bottom + 12).horizontally(20)
    scrollView.contentSize = content.frame.size
  }
  
  override func setupUI() {
    super.setupUI()
    setTitle("장부작성")
    
    dateTextField.setError() { [weak self] text in
      if text.isEmpty { return (false, "날짜를 입력해주세요") }
      let pattern = "^\\d{4}/(0[1-9]|1[012])/(0[1-9]|[12]\\d|3[01])$"
      let regex = try! NSRegularExpression(pattern: pattern)
      
      if !(regex.firstMatch(in: text, range: NSRange(location: 0, length: text.count)) != nil) {
        return (false, "올바른 날짜를 입력해 주세요")
      }
      
      if let year = Int(text.prefix(4)), year < 2015 {
        return (false, "2015년 이후 날짜를 입력해주세요")
      }
      
      if let currentDate = self?.reactor?.formatter.convertToDate(date: .now) {
        let currentDateList = currentDate.split(separator: "/")
        let inputDateList = text.split(separator: "/")
        for i in 0..<3 {
          if Int(inputDateList[i])! > Int(currentDateList[i])! {
            return (false, "미래 날짜는 입력이 불가능합니다")
          } else if Int(inputDateList[i])! == Int(currentDateList[i])! {
            continue
          } else {
            break
          }
        }
      }
      return (true, nil)
    }
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    rootContainer.flex.define { flex in
      flex.addItem(scrollView).shrink(1).define { flex in
        flex.addItem(content).define { flex in
          flex.addItem().marginTop(12).marginHorizontal(20).define { flex in
            flex.addItem(sourceTextField).marginBottom(24)
            flex.addItem(amountTextField).marginBottom(24)
            
            flex.addItem().define { flex in
              flex.addItem(selectionLabel).marginBottom(8)
              flex.addItem(fundTypeSelection)
            }.marginBottom(24)
            
            flex.addItem(dateTextField).marginBottom(24)
            flex.addItem(timeTextField).marginBottom(24)
            flex.addItem(memoTextView).marginBottom(24)
            flex.addItem().direction(.row).define { flex in
              flex.addItem(UILabel().text("카테고리", font: Fonts.body._2, color: Colors.Gray._6))
              flex.addItem().grow(1)
              flex.addItem(categoryEditButton)
            }.marginBottom(8)
            flex.addItem(chipListView)
            .marginBottom(24)
            flex.addItem(UILabel().text("사진 첨부 (최대 12장)", font: Fonts.body._2, color: Colors.Gray._6))
            flex.addItem(documentCollectionView).marginBottom(24).marginRight(-8)
            flex.addItem().alignItems(.start).define { flex in
              flex.addItem(writerTitleLabel).marginBottom(8)
              flex.addItem(writerNameLabel)
            }
            .marginBottom(25)
          }
        }
      }
      
      flex.addItem(smogView).position(.absolute).bottom(0).horizontally(0).height(100)
    }
    view.addSubview(completeButton)
  }
  
  func bind(reactor: CreateManualLedgerReactor) {
    
    startingType = reactor.initialState.type
    setRightItem(.closeBlack)
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
  
  private func bindAction(reactor: CreateManualLedgerReactor) {
    navigationItem.rightBarButtonItem?.rx.tap
      .map { Reactor.Action.didTapCancelButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    rx.viewDidLoad
      .map { Reactor.Action.onAppear }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    content.rx.tapGesture
      .bind { $0.endEditing(true) }
      .disposed(by: disposeBag)
    
    documentCollectionView.rx.modelSelected(ImageData.Item.self)
      .filter { $0 == .button }
      .bind(with: self) { owner, _ in
        owner.imagePicker(target: owner, animated: true, delegate: owner)
    }.disposed(by: disposeBag)
    
    completeButton.rx.tap
      .map { Reactor.Action.didTapCompleteButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    sourceTextField.textField.rx.text
      .skip(1)
      .compactMap { $0 }
      .map { [weak self] in Reactor.Action.inputContent(.source($0, self?.sourceTextField.state != .error)) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    sourceTextField.clearButton.rx.tap
      .map { Reactor.Action.inputContent(.source("", false)) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    amountTextField.textField.rx.text
      .skip(1)
      .compactMap { $0 }
      .map { [weak self] in Reactor.Action.inputContent(.amount($0, self?.amountTextField.state != .error)) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    amountTextField.clearButton.rx.tap
      .map { Reactor.Action.inputContent(.amount("", false)) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    timeTextField.textField.rx.text
      .skip(1)
      .compactMap { $0 }
      .map { [weak self] in Reactor.Action.inputContent(.time($0, self?.timeTextField.state != .error)) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    timeTextField.clearButton.rx.tap
      .map { Reactor.Action.inputContent(.time("", true)) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    fundTypeSelection.$selectedIndex
      .removeDuplicates()
      .sink {
        reactor.action.onNext(.inputContent(.fundType($0)))
      }
      .store(in: &cancelBag)
    
    dateTextField.textField.rx.text
      .skip(1)
      .compactMap { $0 }
      .map { [weak self] in Reactor.Action.inputContent(.date($0, self?.dateTextField.state != .error)) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    dateTextField.clearButton.rx.tap
      .map { Reactor.Action.inputContent(.date("", false)) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    memoTextView.textView.rx.text
      .skip(1)
      .compactMap { $0 }
      .bind(with: self) { owner, value in
        owner.view.setNeedsLayout()
        reactor.action.onNext(.inputContent(.memo(value)))
      }
      .disposed(by: disposeBag)
    
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
      .bind(with: self) { owner, noti in
        guard let keyboardFrame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        owner.scrollView.contentInset.bottom = keyboardHeight
      }.disposed(by: disposeBag)
    
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
      .bind(with: self) { owner, _ in
        owner.scrollView.contentInset.bottom = 100
      }.disposed(by: disposeBag)
    
    categoryEditButton.rx.tap
      .map { Reactor.Action.didTapCategoryEditButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    chipListView.chipTapAction = { _, index in
      let category = reactor.currentState.categories[index]
      reactor.action.onNext(.inputContent(.category(category)))
    }
  }
  
  private func bindState(reactor: CreateManualLedgerReactor) {
    reactor.pulse(\.$documentImages)
      .bind(to: documentCollectionView.rx.items) { [weak self] view, row, element in
        let indexPath = IndexPath(row: row, section: 0)
        switch element {
        case .button:
          return view.dequeueCell(AddImageCell.self, for: indexPath)
        case .image:
          return view.dequeueCell(ImageCell.self, for: indexPath)
            .configure(with: element) {
              self?.reactor?.action.onNext(
                .didTapImageDeleteButton(element)
              )
            }
        }
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$documentImages)
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, value in
        owner.updateCollectionHeigh(
          collectionView: owner.documentCollectionView,
          images: value
        )
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.content.$source)
      .bind(to: sourceTextField.textField.rx.text)
      .disposed(by: disposeBag)
      
    reactor.pulse(\.content.$fundType)
      .bind(with: self) { owner, value in
        owner.fundTypeSelection.selectedIndex = value
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.content.$amount)
      .bind(to: amountTextField.textField.rx.text)
      .disposed(by: disposeBag)
    
    reactor.pulse(\.content.$date)
      .bind(to: dateTextField.textField.rx.text)
      .disposed(by: disposeBag)
    
    reactor.pulse(\.content.$time)
      .bind(to: timeTextField.textField.rx.text)
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$userName)
      .filter { $0.isEmpty == false }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, name in
        owner.writerNameLabel.setTextWithLineHeight(text: name, lineHeight: 20)
        owner.writerNameLabel.flex.markDirty()
        owner.writerNameLabel.setNeedsLayout()
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$destination)
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, destination in
        switch destination {
        case .ledger:
          owner.dismiss(animated: true)
        case let .categorySheet(agencyId, categories):
          owner.coordinator?.present(.categorySheet(agencyId: agencyId, categories: categories))
        case .none:
          break
        }
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$alertMessage)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, content in
        let (title, subTitle, type) = content
        let alert: MMAlerts.`Type`
        switch type {
        case .error(_):
          alert = .onlyOkButton()
        case let .deleteImage(item):
          alert = .default(okAction: { [weak reactor] in
            reactor?.action.onNext(.didTapImageDeleteAlertButton(item))
          })
        case .end:
          alert = .default(okAction: { [weak owner] in
            owner?.dismiss(animated: true)
          })
        }
        AlertsManager.show(title: title, subTitle: subTitle, type: alert)
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$isButtonEnabled)
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, isEnabled in
        owner.completeButton.setState(isEnabled ? .primary : .disable)
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.content.$category)
      .skip(1)
      .bind(with: self) { owner, category in
        let offset = owner.scrollView.contentOffset
        owner.chipListView.selectChip(category?.name)
        owner.rootContainer.flex.layout(mode: .adjustHeight)
        owner.scrollView.setContentOffset(offset, animated: false)
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$categories)
      .filter { !$0.isEmpty }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, categories in
        owner.chipListView.setupChips(with: categories.map(\.name))
        owner.rootContainer.flex.layout(mode: .adjustHeight)
      }
      .disposed(by: disposeBag)
  }
  
  private func updateCollectionHeigh(
    collectionView: UICollectionView,
    images: [ImageData.Item]
  ) {
    let imageCount = images.count
    let lineCount = ceil(Double(imageCount) / 3)
    let baseH = ViewSize.collectionBaseHeight
    collectionView.flex.height(
      baseH + (ViewSize.cell.height + ViewSize.cellSpacing) * (lineCount - 1)
    ).markDirty()
    view.setNeedsLayout()
  }
}

extension CreateManualLedgerVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[.originalImage] as? UIImage {
      Task {
        guard let data = image.jpegData(compressionQuality: 1.0) else { return }
        reactor?.action.onNext(
          .selectedImage(ImageData.Item.image(.init(id: .init(), data: data)))
        )
      }
    }
    dismiss(animated: true, completion: nil)
  }
}
