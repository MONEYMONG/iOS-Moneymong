import UIKit
import Combine

import BaseFeature
import DesignSystem

import ReactorKit
import RxDataSources

final class ManualInputVC: BaseVC, View {
  weak var coordinator: ManualInputCoordinator?
  private struct ViewSize {
    static var cell: CGSize {
      let width = UIScreen.main.bounds.width * 0.28
      let height = width * 1.33
      return CGSize(width: width, height: height)
    }
    static var cellSpacing: Double = cell.width * 0.095
    static var receiptHeaderHeight: CGFloat =  31
    static var documentHeaderHeight: CGFloat = 16
    static var collectionBaseHeight: CGFloat = receiptHeaderHeight + documentHeaderHeight + 24 + (ViewSize.cell.height + 8) * 2
  }
  
  var disposeBag = DisposeBag()
  private var anyCancellable = Set<AnyCancellable>()
  
  private let scrollView: UIScrollView = {
    let v = UIScrollView()
    v.keyboardDismissMode = .interactive
    return v
  }()
  private let content = UIView()
  private let smogView = SmogView()
  private let keyboardSpaceView = UIView()
  
  private let completeButton = MMButton(title: "작성하기", type: .disable)

  private let sourceTextField: MMTextField = {
    let v = MMTextField(charactorLimitCount: 20, title: "수입·지출 출처")
    v.setPlaceholder(to: "점포명을 입력해주세요")
    v.setRequireMark()
    return v
  }()
  
  private let amountTextField: MMTextField = {
    let v = MMTextField(title: "금액")
    v.setPlaceholder(to: "거래 금액을 입력해주세요")
    v.setRequireMark()
    v.setKeyboardType(to: .numberPad)
    return v
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
    let v = MMTextField(title: "날짜")
    v.setPlaceholder(to: "YYYY/MM/DD")
    v.setRequireMark()
    v.setKeyboardType(to: .numberPad)
    return v
  }()
  
  private let timeTextField: MMTextField = {
    let v = MMTextField(title: "시간")
    v.setPlaceholder(to: "00:00:00(24시 단위)")
    v.setRequireMark()
    v.setKeyboardType(to: .numberPad)
    return v
  }()
  
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = ViewSize.cell
    layout.minimumLineSpacing = ViewSize.cellSpacing
    layout.minimumInteritemSpacing = ViewSize.cellSpacing
    layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 24, right: 8)
    let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
    v.register(AddImageCell.self)
    v.register(ImageCell.self)
    v.registerHeader(ReceiptHeader.self)
    v.registerHeader(DocumentHeader.self)
    v.isScrollEnabled = false
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
  
  private let memoTextView: MMTextView = {
    let v = MMTextView(charactorLimitCount: 300, title: "메모")
    v.setPlaceholder(to: "메모할 내용을 입력하세요")
    return v
  }()
  
  override init() {
    super.init()
  }
  
  @available(*, unavailable)
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    completeButton.pin.height(56).bottom(view.safeAreaInsets.bottom + 12).horizontally(20)
    scrollView.contentSize = content.frame.size
  }
  
  override func setupUI() {
    super.setupUI()
    setTitle("장부 작성")

  }
  
  override func setupConstraints() {
    super.setupConstraints()
    rootContainer.flex.define { flex in
      flex.addItem(scrollView).shrink(1).define { flex in
        flex.addItem(content).marginTop(12).marginHorizontal(20).define { flex in
          flex.addItem(sourceTextField).marginBottom(24)
          flex.addItem(amountTextField).marginBottom(24)
          flex.addItem().define { flex in
            flex.addItem(selectionLabel).marginBottom(8)
            flex.addItem(fundTypeSelection)
          }.marginBottom(24)
          flex.addItem(dateTextField).marginBottom(24)
          flex.addItem(timeTextField).marginBottom(24)
          flex.addItem().define { flex in
            flex.addItem(collectionView).marginRight(-8)
          }.marginBottom(24)
          flex.addItem(memoTextView)
        }.paddingBottom(50)
      }
      flex.addItem(keyboardSpaceView).backgroundColor(.clear).height(60)
      flex.addItem(smogView).position(.absolute).bottom(0).horizontally(0).height(100)
    }
    view.addSubview(completeButton)
  }
  
  func bind(reactor: ManualInputReactor) {
    setRightItem(.closeBlack)
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
  
  private func bindAction(reactor: ManualInputReactor) {
    navigationItem.rightBarButtonItem?.rx.tap
      .map { Reactor.Action.presentedAlert(.end) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    collectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    collectionView.rx.modelSelected(ImageSectionModel.Item.self)
      .filter { $0 == .button(.receipt) || $0 == .button(.document) }
      .bind(with: self) { owner, value in
        guard case let .button(section) = value else { return }
        reactor.action.onNext(.didTapImageAddButton(section))
    }.disposed(by: disposeBag)
    
    completeButton.rx.tap
      .bind(with: self) { owner, _ in
        print("작성 완료")
      }
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
      .sink {
        reactor.action.onNext(.inputContent("\($0)", type: .fundType))
    }.store(in: &anyCancellable)
    
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
        owner.keyboardSpaceView.flex.height(
          keyboardHeight - owner.view.safeAreaInsets.bottom
        ).markDirty()
        owner.rootContainer.flex.layout()
      }.disposed(by: disposeBag)
    
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
      .bind(with: self) { owner, _ in
        owner.keyboardSpaceView.flex.height(60).markDirty()
        owner.rootContainer.flex.layout()
      }.disposed(by: disposeBag)
    
    NotificationCenter.default.rx.notification(.didTapImageDeleteButton)
      .map { $0.object as! ImageSectionModel.Item }
      .map { Reactor.Action.presentedAlert(.deleteImage($0)) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  private func bindState(reactor: ManualInputReactor) {
    reactor.pulse(\.$images)
      .observe(on: MainScheduler.instance)
      .bind(to: collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$images)
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, value in
        owner.updateCollectionHeigh(images: value)
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$selectedSection)
      .compactMap { $0 }
      .bind(with: self) { owner, _ in
        owner.coordinator?.present(.imagePicker(delegate: owner))
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
    
    reactor.pulse(\.$alertMessage)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, content in
        let (title, subTitle, type) = content
        let okAction: () -> Void = {
          switch type {
          case .error(_):
            break
          case .deleteImage(let item):
            reactor.action.onNext(.didTapImageDeleteAlertButton(item))
          case .end:
            owner.coordinator?.dismiss(animated: true)
          }
        }
        var cancelAction: (() -> Void)? = nil
        switch type {
        case .error(_): break
        case .deleteImage(_), .end: cancelAction = {}
        }
        owner.coordinator?.present(
          .alert(
            title: title,
            subTitle: subTitle,
            okAction: okAction,
            cancelAction: cancelAction
          ),
          animated: false
        )
      }
      .disposed(by: disposeBag)
//
//    reactor.pulse(\.$isValids)
//      .compactMap { $0[.amount] }
//      .distinctUntilChanged()
//      .filter { $0 == false }
//      .bind(with: self, onNext: { owner, isValid in
//        owner.amountTextField.setError(message: "999,999,999원 이내로 입력해주세요")
//        owner.amountTextField.flex.markDirty()
//        owner.view.setNeedsLayout()
//      })
//      .disposed(by: disposeBag)
  }
  
  private func updateCollectionHeigh(images: [ImageSectionModel.Model]) {
    let receiptImageCount = images[0].items.count
    let supportingImageCount = images[1].items.count
    let receiptLineCount = ceil(Double(receiptImageCount) / 3)
    let supportingLineCount = ceil(Double(supportingImageCount) / 3)
    let baseH = ViewSize.collectionBaseHeight
    collectionView.flex.height(
      baseH + (ViewSize.cell.height + ViewSize.cellSpacing) * (receiptLineCount + supportingLineCount - 2)
    ).markDirty()
    view.setNeedsLayout()
  }
}

extension ManualInputVC: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    if section == 0 {
      return CGSize(
        width: collectionView.frame.width,
        height: ViewSize.receiptHeaderHeight
      )
    } else {
      return CGSize(
        width: collectionView.frame.width,
        height: ViewSize.documentHeaderHeight
      )
    }
  }
}

extension ManualInputVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[.originalImage] as? UIImage {
      Task {
        let scale = ViewSize.cell.width / image.size.width
        guard let data = image.jpegData(compressionQuality: scale) else { return }
        if reactor?.currentState.selectedSection == .receipt {
          reactor?.action.onNext(
            .selectedImage(
              .image(.init(id: .init(), data: data), .receipt)
            )
          )
        } else {
          reactor?.action.onNext(
            .selectedImage(
              .image(.init(id: .init(), data: data), .document)
            )
          )
        }
      }
    }
    dismiss(animated: true, completion: nil)
  }
}
