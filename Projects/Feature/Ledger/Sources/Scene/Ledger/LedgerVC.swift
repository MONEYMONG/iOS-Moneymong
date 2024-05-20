import UIKit

import BaseFeature
import ReactorKit
import PinLayout
import FlexLayout
import DesignSystem

public final class LedgerVC: BaseVC, View {
  public var disposeBag = DisposeBag()
  weak var coordinator: LedgerCoordinator?
  
  private let agencyButton: UIButton = {
    var title = AttributedString("소속 없음")
    title.font = Fonts.heading._1
    title.foregroundColor = Colors.Gray._10
    
    var config = UIButton.Configuration.plain()
    config.attributedTitle = title
    config.image = Images.chevronDown?.withTintColor(Colors.Gray._10)
    config.imagePadding = 4
    config.imagePlacement = .trailing
    
    let v = UIButton(configuration: config)
    v.frame = .init(x: 0, y: 0, width: 200, height: 0)
    
    return v
  }()
  
  private let lineTab: LineTabViewController
  
  init(_ childVC: [UIViewController]) {
    self.lineTab = LineTabViewController(childVC)
    super.init()
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }
  
  public override func setupUI() {
    super.setupUI()
  }
  
  public override func setupConstraints() {
    super.setupConstraints()
    rootContainer.flex
      .define { flex in
        flex.addItem(lineTab.view)
      }
  }
  
  public func bind(reactor: LedgerReactor) {
    setTitle(agencyButton)
    
    rx.viewWillAppear
      .map { Reactor.Action.requestMyAgencies }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$agency)
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, agency in
        var title = AttributedString(agency?.name ?? "소속없음")
        title.font = Fonts.heading._1
        title.foregroundColor = Colors.Gray._10
        
        owner.agencyButton.configuration?.attributedTitle = title
      }
      .disposed(by: disposeBag)
    
    agencyButton.rx.tap
      .bind(with: self) { owner, _ in
        owner.coordinator?.present(.selectAgency)
      }
      .disposed(by: disposeBag)
  }
}
