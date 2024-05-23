import UIKit

import DesignSystem
import BaseFeature

import PinLayout
import FlexLayout
import RxSwift

final class ScanGuideVC: BaseVC {
  private let disposeBag = DisposeBag()
  
  private let closeButton: UIButton = {
    let v = UIButton()
    let image = Images.close?.withRenderingMode(.alwaysTemplate)
    v.tintColor = Colors.White._1
    v.setImage(image, for: .normal)
    return v
  }()
  
  private let headerLabel: UILabel = {
    let v = UILabel()
    v.font = Fonts.heading._2
    v.numberOfLines = 2
    v.setTextWithLineHeight(text: "실물 영수증 혹은 전자 영수증을\n촬영해 주세요.", lineHeight: 28)
    v.textColor = .white
    v.textAlignment = .center
    return v
  }()
  
  private let descriptionLabel: UILabel = {
    let v = UILabel()
    v.font = Fonts.body._4
    v.numberOfLines = 6
    v.setTextWithLineHeight(text: "텍스트가 육안으로 보일 수준으로\n찍어야지 정확하게 인식할 수 있습니다.\n\n점포명, 날짜와 시간, 합계 금액이 정확하게\n스캔되도록 영수증의 처음과 끝이\n모두 포함되게 인식해 주세요.", lineHeight: 24)
    v.textColor = Colors.Gray._2
    v.textAlignment = .center
    return v
  }()
  
  private let blurEffect: UIVisualEffectView = {
    let v = UIVisualEffectView()
    let effect = UIBlurEffect(style: .dark)
    v.effect = effect
    v.alpha = 0.7
    return v
  }()
  
  private let tapContanier = UIView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin.all(view.pin.safeArea)
    rootContainer.flex.layout()
    blurEffect.pin.all()
  }
  
  override func setupUI() {
    super.setupUI()
    view.backgroundColor = .black.withAlphaComponent(0.8)
    let appearance = UINavigationBarAppearance()
    appearance.configureWithTransparentBackground()
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    navigationController?.navigationBar.standardAppearance = appearance
  }
  
  override func setupConstraints() {
    view.addSubview(blurEffect)
    super.setupConstraints()
    
    rootContainer.flex.alignItems(.center).define { flex in
      flex.addItem().define { flex in
        flex.addItem(headerLabel).marginBottom(20)
        flex.addItem(descriptionLabel)
      }.marginTop(30)
      flex.addItem(UIImageView(image: Images.scanGuide)).marginTop(24)
    }
  }
  
  private func bind() {
    setRightItem(.closeWhite)
    navigationItem.rightBarButtonItem?.rx.tap
      .bind(with: self) { owner, _ in
        owner.dismiss(animated: false)
      }
      .disposed(by: disposeBag)
    
    view.rx.tapGesture
      .bind(with: self) { owner, _ in
        owner.dismiss(animated: false)
      }
      .disposed(by: disposeBag)
  }
}
