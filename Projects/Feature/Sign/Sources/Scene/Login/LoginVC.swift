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

  private let recentProviderToolTip: ToolTip = {
    let tooltip = ToolTip(type: .bottom)
    tooltip.setTitle(with: Const.bubbleTitle)
    tooltip.setBackgroundColor(with: Colors.White._1)
    tooltip.setCorneradius(8)
    tooltip.setFonts(with: Fonts.body._3)
    tooltip.setTitleColor(with: Colors.Blue._4)
    tooltip.isHidden = true
    return tooltip
  }()

  private let appleLoginButton = SocialLoginButton(type: .apple)
  private let kakaoLoginButton = SocialLoginButton(type: .kakao)

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
      .define { flex in

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
          .marginBottom(46)
          .define { flex in

            flex.addItem(appleLoginButton)
              .backgroundColor(Colors.Black._1)
              .height(56)

            flex.addItem().height(12)

            flex.addItem(kakaoLoginButton)
              .backgroundColor(Colors.Yellow._1)
              .height(56)
          }
      }

    rootContainer.addSubview(recentProviderToolTip)
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
      .delay(.milliseconds(10), scheduler: MainScheduler.instance)
      .bind(with: self) { owner, type in

        owner.recentProviderToolTip.isHidden = false

        switch type {
        case .apple:
          owner.recentProviderToolTip.pin
            .hCenter()
            .after(of: owner.appleLoginButton, aligned: .bottom)
            .marginBottom(63)

        case .kakao:
          owner.recentProviderToolTip.pin
            .hCenter()
            .after(of: owner.kakaoLoginButton, aligned: .bottom)
            .marginBottom(63)
        }
      }
      .disposed(by: disposeBag)

    reactor.pulse(\.$errorMessage)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, errorMessage in
        owner.coordinator?.alert(title: errorMessage)
      }
      .disposed(by: disposeBag)

    reactor.pulse(\.$isLoading)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(to: rx.isLoading)
      .disposed(by: disposeBag)

    // Action Binding

    rx.viewDidAppear
      .map { Reactor.Action.onAppear }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    appleLoginButton.rx.tap
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .map { Reactor.Action.login(.apple) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    kakaoLoginButton.rx.tap
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .map { Reactor.Action.login(.kakao) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
}

fileprivate enum Const {
  static var title: String { "교내 회계 관리를 편리하게" }
  static var description: String { "수기 기록은 이제 그만! 간단하게 기록해요." }
  static var bubbleTitle: String { "마지막으로 로그인한 계정이에요" }
  static var kakaoButtonTitle: String { "카카오 로그인" }
  static var appleButtonTitle: String { "Apple로 로그인" }
}

