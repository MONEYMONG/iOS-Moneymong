import UIKit

import BaseFeature
import DesignSystem

import ReactorKit
import RxCocoa

final class CreateCompleteVC: BaseVC, View {
  var disposeBag = DisposeBag()
  weak var coordinator: AgencyCoordinator?
  
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
  
  override func setupUI() {
    super.setupUI()
    setTitle("등록완료", color: Colors.White._1)
    view.backgroundColor = Colors.Gray._7
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
        flex.addItem(registerLedgerButton).height(56)
      }
    }
  }
  
  func bind(reactor: CreateCompleteReactor) {
    setRightItem(.closeBlack, color: Colors.White._1)
    
    navigationItem.rightBarButtonItem?.rx.tap
      .bind(with: self) { owner, _ in
        owner.coordinator?.dismiss()
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$destination)
      .compactMap { $0 }
      .bind(with: self) { owner, destination in
        switch destination {
        case .ledger:
          owner.coordinator?.goLedger()
        case .registerLedger:
          owner.coordinator?.goCreateLedger()
        }
      }
      .disposed(by: disposeBag)
  }
}
