import UIKit

import DesignSystem
import BaseFeature
import ReactorKit

final class LoginVC: BaseVC, View {

  weak var coordinator: SignCoordinator?
  var disposeBag = DisposeBag()

  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = Images.mongStudy
    return imageView
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = Const.title
    label.font = Fonts.heading._2
    label.textColor = .white
    return label
  }()

  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.text = Const.description
    label.font = Fonts.body._3
    label.textColor = .white
    return label
  }()

  private let appleLogin: UIButton = {
    let button = UIButton()
    button.setImage(Images.apple, for: .normal)
    return button
  }()

  private let kakaoLogin: UIButton = {
    let button = UIButton()
    button.setImage(Images.kakao, for: .normal)
    return button
  }()

  override func setupConstraints() {
    super.setupConstraints()
    rootContainer.flex
      .backgroundColor(Colors.Blue._4)
      .alignItems(.center)
      .justifyContent(.center)
      .direction(.column)
      .define { flex in

        flex.addItem()
          .direction(.column)
          .alignSelf(.center)
          .alignItems(.center)
          .justifyContent(.center)
          .define { flex in
            flex.addItem(imageView)
            flex.addItem().height(12)
            flex.addItem(titleLabel)
            flex.addItem().height(2)
            flex.addItem(descriptionLabel)
          }

        flex.addItem()
          .position(.absolute).bottom(46)
          .alignItems(.center)
          .justifyContent(.center)
          .direction(.column)
          .paddingHorizontal(20)
          .define { flex in
            flex.addItem(appleLogin)
            flex.addItem().height(12)
            flex.addItem(kakaoLogin)
          }
      }
  }

  func bind(reactor: LoginReactor) {
    reactor.state
      .map { $0.info }
//      .distinctUntilChanged()
      .bind(with: self) { owner, isSign in
        print("asdsadsadasdasdasdsad", isSign)
      }
      .disposed(by: disposeBag)

    appleLogin.rx.tap
      .bind(with: self) { owner, _ in
        reactor.action.onNext(.apple)
      }
      .disposed(by: disposeBag)

    kakaoLogin.rx.tap
      .bind(with: self) { owner, _ in
        reactor.action.onNext(.kakao)
//        owner.coordinator?.main()
      }
      .disposed(by: disposeBag)
  }
}

fileprivate enum Const {
  static var title: String { "교내 회계 관리를 편리하게" }
  static var description: String { "수기 기록은 이제 그만! 간단하게 기록해요." }
}
