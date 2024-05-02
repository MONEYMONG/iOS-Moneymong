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

  private let recentProviderBubble: Bubble = {
    let bubble = Bubble()
    bubble.setTitle(to: Const.bubbleTitle)
    bubble.isHidden = true
    bubble.flex.display(.none)
    return bubble
  }()

  private let appleLoginButton: UIButton = {
    let button = UIButton()
    button.setImage(Images.appleButton, for: .normal)
    return button
  }()

  private let kakaoLoginButton: UIButton = {
    let button = UIButton()
    button.setImage(Images.kakaoButton, for: .normal)
    return button
  }()

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = true
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.navigationBar.isHidden = false
  }

  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }

  override func setupConstraints() {
    super.setupConstraints()
    rootContainer.flex
      .backgroundColor(Colors.Blue._4)
      .alignItems(.center)
      .justifyContent(.center)
      .define { flex in

        flex.addItem(recentProviderBubble).position(.absolute)

        flex.addItem().grow(1)

        flex.addItem()
          .direction(.column)
          .alignSelf(.center)
          .alignItems(.center)
          .marginTop(46)
          .justifyContent(.center)
          .define { flex in
            flex.addItem(imageView)
            flex.addItem().height(12)
            flex.addItem(titleLabel)
            flex.addItem().height(2)
            flex.addItem(descriptionLabel)
          }

        flex.addItem().grow(1)

        flex.addItem()
          .direction(.column)
          .paddingHorizontal(20)
          .alignItems(.center)
          .marginBottom(46)
          .define { flex in
            flex.addItem(appleLoginButton).marginBottom(12)
            flex.addItem(kakaoLoginButton)
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

    reactor.pulse(\.$recentLoginType)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, type in
        switch type {
        case .apple:
          owner.recentProviderBubble.flex.bottom(154)
        case .kakao:
          owner.recentProviderBubble.flex.bottom(84)
        }
        owner.recentProviderBubble.isHidden = false
        owner.recentProviderBubble.flex.display(.flex).markDirty()
        owner.recentProviderBubble.flex.layout()
        owner.rootContainer.setNeedsLayout()
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

    appleLoginButton.rx.tap
      .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
      .map { Reactor.Action.login(.apple) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    kakaoLoginButton.rx.tap
      .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
      .map { Reactor.Action.login(.kakao) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
}

fileprivate enum Const {
  static var title: String { "교내 회계 관리를 편리하게" }
  static var description: String { "수기 기록은 이제 그만! 간단하게 기록해요." }
  static var bubbleTitle: String { "마지막으로 로그인한 계정이에요" }
}
