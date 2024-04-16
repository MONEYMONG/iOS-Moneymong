import UIKit

import DesignSystem
import BaseFeature
import ReactorKit

final class SplashVC: BaseVC, View {

  var coordinator: SignCoordinator?
  var disposeBag = DisposeBag()

  private let logoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = Images.mong
    return imageView
  }()

  override func setupConstraints() {
    super.setupConstraints()
    rootContainer.flex
      .backgroundColor(Colors.Blue._4)
      .direction(.column)
      .justifyContent(.center)
      .alignItems(.center)
      .define { flex in

        flex.addItem(logoImageView)
          .width(120)
          .height(120)
          .aspectRatio(of: logoImageView)
      }
  }

  func bind(reactor: SplashReactor) {
    rx.viewDidLoad
      .bind(with: self) { owner, _ in
        owner.transitionToMainScene()
      }
      .disposed(by: disposeBag)
  }

  private func transitionToMainScene() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
      guard let self = self else { return }
      self.coordinator?.login()
    }
  }
}
