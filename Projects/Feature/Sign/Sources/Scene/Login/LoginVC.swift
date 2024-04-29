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

  public override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.isHidden = true
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

    reactor.pulse(\.$moveToMain)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, _ in
        owner.coordinator?.main()
      }
      .disposed(by: disposeBag)

    reactor.pulse(\.$errorMessage)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, errorMessage in
        AlertsManager.show(owner, title: errorMessage, subTitle: nil, okAction: {}, cancelAction: nil)
      }
      .disposed(by: disposeBag)

    //    reactor.pulse(\.$isLoading)
    //      .compactMap { $0 }
    //      .observe(on: MainScheduler.instance)
    //      .bind(to: rx.isLoading())
    //      .disposed(by: disposeBag)

    // Action Binding

    appleLogin.rx.tap
      .map { Reactor.Action.login(.Apple) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    kakaoLogin.rx.tap
      .map { Reactor.Action.login(.Kakao) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
}

fileprivate enum Const {
  static var title: String { "교내 회계 관리를 편리하게" }
  static var description: String { "수기 기록은 이제 그만! 간단하게 기록해요." }
}
