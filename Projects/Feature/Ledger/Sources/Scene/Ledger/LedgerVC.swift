import UIKit

import BaseFeature
import ReactorKit
import PinLayout
import FlexLayout
import DesignSystem

public final class LedgerVC: BaseVC, View {
  public var disposeBag = DisposeBag()
  weak var coordinator: LedgerCoordinator?
  
  private let emptyView: LedgerEmptyView = {
    let v = LedgerEmptyView()
    v.isHidden = true
    return v
  }()
  
  private let agencyButton: UIButton = {
    var title = AttributedString("소속 없음")
    title.font = Fonts.heading._1
    title.foregroundColor = Colors.Gray._10
    
    var config = UIButton.Configuration.plain()
    config.attributedTitle = title
    config.image = Images.chevronDown?.withTintColor(Colors.Gray._10)
    config.imagePadding = 4
    config.imagePlacement = .trailing
    config.titleLineBreakMode = .byTruncatingTail
    
    let v = UIButton(configuration: config)
    
    return v
  }()
  
  private let lineTab: LineTabViewController
  
  init(_ childVC: [UIViewController]) {
    self.lineTab = LineTabViewController(childVC)
    super.init()
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    emptyView.pin.all()
    agencyButton.frame = .init(
      x: 0,
      y: 0,
      width: 350,
      height: 0
    )
  }
  
  public override func setupConstraints() {
    super.setupConstraints()
    view.addSubview(emptyView)
    
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
    
    rx.viewDidLoad
      .bind(with: self, onNext: { owner, _ in
        owner.coordinator?.moveTab = { owner.lineTab.currentPage = $0 }
      })
      .disposed(by: disposeBag)
    
    emptyView.tapAgency
      .bind(with: self) { owner, _ in
        owner.coordinator?.goAgency()
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$agency)
      .skip(1)
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, agency in
        var title = AttributedString(agency?.name ?? "장부")
        title.font = Fonts.heading._1
        title.foregroundColor = Colors.Gray._10
        
        owner.agencyButton.configuration?.attributedTitle = title
        
        if agency == nil {
          owner.agencyButton.configuration?.image = nil
          owner.emptyView.isHidden = false
        } else {
          owner.agencyButton.configuration?.image = Images.chevronDown?.withTintColor(Colors.Gray._10)
          owner.emptyView.isHidden = true
        }
      }
      .disposed(by: disposeBag)
    
    agencyButton.rx.tap
      .bind(with: self) { owner, _ in
        owner.coordinator?.present(.selectAgency)
      }
      .disposed(by: disposeBag)
  }
}
