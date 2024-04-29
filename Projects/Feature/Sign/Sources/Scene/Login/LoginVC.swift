import UIKit

import DesignSystem
import BaseFeature
import ReactorKit

final class LoginVC: BaseVC, View {

  weak var coordinator: SignCoordinator?
  var disposeBag = DisposeBag()

  private let button: UIButton = {
    let button = UIButton()
    button.configuration = UIButton.Configuration.borderedProminent()
    button.configuration?.title = "소셜 로그인"
    return button
  }()

  override func setupConstraints() {
    super.setupConstraints()
    rootContainer.flex
      .direction(.column)
      .justifyContent(.center)
      .alignItems(.center)
      .define { flex in
        flex.addItem(button).marginHorizontal(20)
      }
  }

  func bind(reactor: LoginReactor) {
    button.rx.tap
      .bind(with: self) { owner, _ in
        owner.coordinator?.main()
      }
      .disposed(by: disposeBag)
  }
}
