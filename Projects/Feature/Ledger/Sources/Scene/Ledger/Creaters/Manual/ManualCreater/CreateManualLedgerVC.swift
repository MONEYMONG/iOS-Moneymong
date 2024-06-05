import UIKit
import Combine

import BaseFeature
import DesignSystem

import ReactorKit
import RxDataSources
import PinLayout
import FlexLayout

// TODO: 각 텍스트 필드에 조건 넣어줘야함

final class CreateManualLedgerVC: BaseVC, View {
  weak var coordinator: CreateManualLedgerCoordinator?
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
  private var startingType: CreateManualLedgerReactor.`Type` = .createManual
  
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
  private let recepitImageView: UIImageView = {
    let v = UIImageView()
    v.contentMode = .scaleAspectFill
    v.clipsToBounds = true
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
      .setError(message: "999,999,999원 이내로 입력해주세요") { text in
        guard let value = Int(text.replacingOccurrences(of: ",", with: "")) else {
          return false
        }
        
        return value <= 999_999_999
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
      .setError(message: "올바른 날짜를 입력해 주세요") { text in
        let pattern = "^\\d{4}/(0[1-9]|1[012])/(0[1-9]|[12]\\d|3[01])$"
        let regex = try! NSRegularExpression(pattern: pattern)
        
        return regex.firstMatch(in: text, range: NSRange(location: 0, length: text.count)) != nil
      }
  }()
  
  private let timeTextField: MMTextField = {
    MMTextField(title: "시간")
      .setPlaceholder(to: "00:00:00(24시 단위)")
      .setRequireMark()
      .setKeyboardType(to: .numberPad)
      .setError(message: "올바른 시간을 입력해 주세요") { text in
        let pattern = "^([01]?[0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$"
        let regex = try! NSRegularExpression(pattern: pattern)
        
        return regex.firstMatch(in: text, range: NSRange(location: 0, length: text.count)) != nil
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
  
  private lazy var receiptCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = ViewSize.cell
    layout.minimumLineSpacing = ViewSize.cellSpacing
    layout.minimumInteritemSpacing = ViewSize.cellSpacing
    layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 8)
    let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
    v.register(AddImageCell.self)
    v.register(ImageCell.self)
    v.isScrollEnabled = false
    v.tag = 0
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
  
  deinit {
    coordinator?.remove()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    completeButton.pin.height(56).bottom(view.safeAreaInsets.bottom + 12).horizontally(20)
    scrollView.contentSize = content.frame.size
  }
  
  override func setupUI() {
    super.setupUI()
    switch startingType {
    case .ocrResultEdit:
      setTitle("상세내역")
    default:
      setTitle("장부작성")
    }
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    rootContainer.flex.define { flex in
      flex.addItem(scrollView).shrink(1).define { flex in
        flex.addItem(content).define { flex in
          switch startingType {
          case .ocrResultEdit:
            flex.addItem(recepitImageView).height(240).marginBottom(16)
          default: break
          }
          flex.addItem().marginTop(12).marginHorizontal(20).define { flex in
            flex.addItem(sourceTextField).marginBottom(24)
            flex.addItem(amountTextField).marginBottom(24)
            
            flex.addItem().define { flex in
              flex.addItem(selectionLabel).marginBottom(8)
              flex.addItem(fundTypeSelection)
            }.marginBottom(24)
            
            flex.addItem(dateTextField).marginBottom(24)
            flex.addItem(timeTextField).marginBottom(24)
            switch startingType {
            case .ocrResultEdit:
              flex.addItem(memoTextView).marginBottom(24)
              flex.addItem(UILabel().text("증빙 자료 (최대 12장)", font: Fonts.body._2, color: Colors.Gray._6))
              flex.addItem(documentCollectionView).marginBottom(24).marginRight(-8)
            default:
              flex.addItem(UILabel().text("영수증 (최대 12장)", font: Fonts.body._2, color: Colors.Gray._6))
              flex.addItem(UILabel().text("*지출일 경우 영수증을 꼭 제출해주세요", font: Fonts.body._2, color: Colors.Blue._4))
              flex.addItem(receiptCollectionView).marginBottom(24).marginRight(-8)
              
              flex.addItem(UILabel().text("증빙 자료 (최대 12장)", font: Fonts.body._2, color: Colors.Gray._6))
              flex.addItem(documentCollectionView).marginBottom(24).marginRight(-8)
              
              flex.addItem(memoTextView).marginBottom(24)
            }
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
    switch reactor.initialState.type {
    case .ocrResultEdit:
      setLeftItem(.back)
      setRightItem(.등록하기)
      completeButton.setTitle(to: "등록하기")
    default:
      setRightItem(.closeBlack)
    }
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
  
  private func bindAction(reactor: CreateManualLedgerReactor) {
    switch reactor.initialState.type {
    case .ocrResultEdit:
      navigationItem.leftBarButtonItem?.rx.tap
        .bind(with: self, onNext: { owner, _ in
          owner.navigationController?.popViewController(animated: true)
        })
        .disposed(by: disposeBag)
      navigationItem.rightBarButtonItem?.rx.tap
        .map { Reactor.Action.didTapCompleteButton }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
    default:
      navigationItem.rightBarButtonItem?.rx.tap
        .map { Reactor.Action.presentedAlert(.end) }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
    }
    
    rx.viewDidLoad
      .map { Reactor.Action.onAppear }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    view.rx.tapGesture
      .bind(with: self) { owner, _ in
        owner.view.endEditing(true)
      }
      .disposed(by: disposeBag)
    
    receiptCollectionView.rx.modelSelected(ImageData.Item.self)
      .filter { $0 == .button }
      .bind(with: self) { owner, _ in
        reactor.action.onNext(.didTapImageAddButton(.receipt))
    }.disposed(by: disposeBag)
    
    documentCollectionView.rx.modelSelected(ImageData.Item.self)
      .filter { $0 == .button }
      .bind(with: self) { owner, _ in
        reactor.action.onNext(.didTapImageAddButton(.document))
    }.disposed(by: disposeBag)
    
    completeButton.rx.tap
      .map { Reactor.Action.didTapCompleteButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    sourceTextField.textField.rx.text
      .compactMap { $0 }
      .map { Reactor.Action.inputContent($0, type: .source) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    sourceTextField.clearButton.rx.tap
      .map { Reactor.Action.inputContent("", type: .source) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    amountTextField.textField.rx.text
      .compactMap { $0 }
      .map { Reactor.Action.inputContent($0, type: .amount) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    amountTextField.clearButton.rx.tap
      .map { Reactor.Action.inputContent("", type: .amount) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    timeTextField.textField.rx.text
      .compactMap { $0 }
      .map { Reactor.Action.inputContent($0, type: .time) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    timeTextField.clearButton.rx.tap
      .map { Reactor.Action.inputContent("", type: .time) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    fundTypeSelection.$selectedIndex
      .removeDuplicates()
      .sink {
        reactor.action.onNext(.inputContent("\($0)", type: .fundType))
      }
      .store(in: &cancelBag)
    
    dateTextField.textField.rx.text
      .compactMap { $0 }
      .map { Reactor.Action.inputContent($0, type: .date) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    memoTextView.textView.rx.text
      .compactMap { $0 }
      .bind(with: self) { owner, value in
        owner.view.setNeedsLayout()
        reactor.action.onNext(.inputContent(value, type: .memo))
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
  }
  
  private func bindState(reactor: CreateManualLedgerReactor) {
    switch reactor.initialState.type {
    case .ocrResultEdit:
      reactor.pulse(\.$receiptImages)
        .compactMap { item -> UIImage? in
          guard case let .image(image) = item.last else { return UIImage() }
          return UIImage(data: image.data)
        }
        .bind(to: recepitImageView.rx.image)
        .disposed(by: disposeBag)
    default:
      reactor.pulse(\.$receiptImages)
        .bind(to: receiptCollectionView.rx.items) { [weak self] view, row, element in
          let indexPath = IndexPath(row: row, section: 0)
          switch element {
          case .button:
            return view.dequeueCell(AddImageCell.self, for: indexPath)
          case .image:
            return view.dequeueCell(ImageCell.self, for: indexPath)
              .configure(with: element) {
                self?.reactor?.action.onNext(.presentedAlert(.deleteImage(element, .receipt)))
              }
          }
        }
        .disposed(by: disposeBag)
      
      reactor.pulse(\.$receiptImages)
        .observe(on: MainScheduler.instance)
        .bind(with: self) { owner, value in
          owner.updateCollectionHeigh(
            collectionView: owner.receiptCollectionView,
            images: value
          )
        }
        .disposed(by: disposeBag)
    }
    
    reactor.pulse(\.$documentImages)
      .bind(to: documentCollectionView.rx.items) { [weak self] view, row, element in
        let indexPath = IndexPath(row: row, section: 0)
        switch element {
        case .button:
          return view.dequeueCell(AddImageCell.self, for: indexPath)
        case .image:
          return view.dequeueCell(ImageCell.self, for: indexPath)
            .configure(with: element) {
              self?.reactor?.action.onNext(.presentedAlert(.deleteImage(element, .document)))
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
    
    reactor.pulse(\.$selectedSection)
      .compactMap { $0 }
      .bind(with: self) { owner, _ in
        owner.coordinator?.present(.imagePicker(delegate: owner))
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
      .filter { $0 == .ledger }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, _ in
        owner.dismiss(animated: true)
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
        case let .deleteImage(item, section):
          alert = .default(okAction: { [weak reactor] in
            reactor?.action.onNext(.didTapImageDeleteAlertButton(item, section))
          })
        case .end:
          alert = .default(okAction: { [weak owner] in
            owner?.dismiss(animated: true)
          })
        }
        owner.coordinator?.present(
          .alert(
            title: title,
            subTitle: subTitle,
            type: alert
          ),
          animated: false
        )
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$isButtonEnabled)
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, isEnabled in
        owner.completeButton.setState(isEnabled ? .primary : .disable)
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
        if reactor?.currentState.selectedSection == .receipt {
          reactor?.action.onNext(
            .selectedImage(
              ImageData.Item.image(.init(id: .init(), data: data)),
              .receipt
            )
          )
        } else {
          reactor?.action.onNext(
            .selectedImage(
              ImageData.Item.image(.init(id: .init(), data: data)),
              .document
            )
          )
        }
      }
    }
    dismiss(animated: true, completion: nil)
  }
}
