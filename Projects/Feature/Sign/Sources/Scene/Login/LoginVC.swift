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
    button.setImage(Images.appleButton, for: .normal)
    return button
  }()

  private let kakaoLogin: UIButton = {
    let button = UIButton()
    button.setImage(Images.kakaoButton, for: .normal)
    return button
  }()

  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }

  override func setupUI() {
    super.setupUI()
    setLeftItem(.none)
  }

  override func setupConstraints() {
    super.setupConstraints()
    rootContainer.flex
      .backgroundColor(Colors.Blue._4)
      .alignItems(.center)
      .justifyContent(.center)
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
    // State Binding

    reactor.pulse(\.$destination)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, destination in
        switch destination {
        case .main:
          owner.coordinator?.main()
        case .signUp:
          owner.coordinator?.signUp()
        }
      }
      .disposed(by: disposeBag)

    reactor.pulse(\.$errorMessage)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, errorMessage in
        owner.coordinator?.alert(title: errorMessage, subTitle: "", okAction: {})
      }
      .disposed(by: disposeBag)

    reactor.pulse(\.$isLoading)
      .observe(on: MainScheduler.instance)
      .bind { isLoading in
        // TODO: 로딩인디케이터 돌리기
      }
      .disposed(by: disposeBag)

    // Action Binding

    appleLogin.rx.tap
      .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
      .map { Reactor.Action.login(.apple) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    kakaoLogin.rx.tap
      .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
      .map { Reactor.Action.login(.kakao) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
}

fileprivate enum Const {
  static var title: String { "교내 회계 관리를 편리하게" }
  static var description: String { "수기 기록은 이제 그만! 간단하게 기록해요." }
}
