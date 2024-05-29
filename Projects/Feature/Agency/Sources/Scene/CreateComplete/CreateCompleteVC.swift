import UIKit

import BaseFeature
import DesignSystem

import RxCocoa
import RxSwift

final class CreateCompleteVC: BaseVC {
  private let disposeBag = DisposeBag()
  weak var coordinator: AgencyCoordinator?
  
  let agencyID: Int
  
  private let completeImageView = UIImageView(image: Images.agencyCongrats)
  private let completeLabel: UILabel = {
    let v = UILabel()
    v.setTextWithLineHeight(text: "등록해주셔서감사합니다", lineHeight: 28)
    v.textColor = Colors.White._1
    v.font = Fonts.heading._1
    return v
  }()
  
  private let ledgerButton = MMButton(title: "소속 장부 확인하러 가기", type: .secondary)
  private let registerLedgerButton = MMButton(title: "동아리 운영비 등록하러 가기", type: .primary)
  
  init(id: Int) {
    self.agencyID = id
    super.init()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bind()
  }
  

  override func setupUI() {
    super.setupUI()
    
    view.backgroundColor = Colors.Gray._7
    setTitle("등록완료", color: Colors.White._1)
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    rootContainer.flex.justifyContent(.center).backgroundColor(Colors.Gray._7).define { flex in
      flex.addItem().alignItems(.center).define { flex in
        flex.addItem(completeImageView).width(188).height(100)
        flex.addItem(completeLabel)
      }

      flex.addItem().position(.absolute).horizontally(20).bottom(12).define { flex in
        flex.addItem(ledgerButton).height(56).marginBottom(12)
        flex.addItem(registerLedgerButton).height(56).marginBottom(12)
      }
    }
  }
  
  func bind() {
    setRightItem(.closeBlack, color: Colors.White._1)
    
    navigationItem.rightBarButtonItem?.rx.tap
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .bind(with: self) { owner, _ in
        owner.coordinator?.dismiss()
      }
      .disposed(by: disposeBag)
    
    ledgerButton.rx.tap
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .bind(with: self) { owner, _ in
        owner.coordinator?.dismiss(animated: false)
        owner.coordinator?.goLedger()
      }
      .disposed(by: disposeBag)
    
    registerLedgerButton.rx.tap
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .bind(with: self) { owner, _ in
        owner.coordinator?.dismiss(animated: false)
        owner.coordinator?.goManualCreater(agencyID: owner.agencyID)
      }
      .disposed(by: disposeBag)
  }
}
