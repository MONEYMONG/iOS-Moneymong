import UIKit

import DesignSystem
import BaseFeature
import ReactorKit

final class SplashVC: BaseVC, View {

  var coordinator: SignCoordinator?
  var disposeBag = DisposeBag()

  private let logoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = Images.mongSplash
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  override func setupUI() {
    super.setupUI()
    setLeftItem(.none)
  }

  override func setupConstraints() {
    super.setupConstraints()

    view.backgroundColor = Colors.Blue._4

    rootContainer.flex
      .backgroundColor(Colors.Blue._4)
      .direction(.column)
      .justifyContent(.center)
      .alignItems(.center)
      .define { flex in

        flex.addItem(logoImageView).size(12)
      }
  }

  func bind(reactor: SplashReactor) {
    reactor.pulse(\.$destination)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .delay(.milliseconds(900), scheduler: MainScheduler.instance)
      .bind(with: self) { owner, destination in
        switch destination {
        case .login:
          owner.coordinator?.login()
        case .main:
          owner.coordinator?.main()
        }
      }
      .disposed(by: disposeBag)

    rx.viewDidAppear
      .bind(with: self) { owner, _ in
        reactor.action.onNext(.onAppear)
        owner.onAnimation()
      }
      .disposed(by: disposeBag)
  }

  private func onAnimation() {
    view.setNeedsLayout()
    logoImageView.flex.width(120).height(120).markDirty()

    UIView.animate(withDuration: 0.5) {
      self.view.layoutIfNeeded()
    }
  }
}
