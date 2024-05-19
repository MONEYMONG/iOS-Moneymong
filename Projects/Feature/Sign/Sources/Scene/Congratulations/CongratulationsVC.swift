import UIKit
import Combine

import DesignSystem
import BaseFeature
import NetworkService

import ReactorKit

final class CongratulationsVC: BaseVC, View {

  weak var coordinator: SignCoordinator?
  var disposeBag = DisposeBag()

  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = Images.mongCongrats
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = Const.title
    label.font = Fonts.heading._2
    label.textColor = Colors.Gray._10
    return label
  }()

  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.text = Const.description
    label.font = Fonts.body._4
    label.textColor = Colors.Gray._5
    return label
  }()

  private let confirmButton: MMButton = {
    let button = MMButton(title: Const.confirmTitle, type: .primary)
    return button
  }()

  override func setupUI() {
    super.setupUI()
    setLeftItem(.none)
    setTitle(Const.navigationBarTitle)
  }

  override func setupConstraints() {
    super.setupConstraints()
    rootContainer.flex
      .paddingHorizontal(20)
      .backgroundColor(Colors.White._1)
      .define { flex in
        flex.addItem().grow(1)

        flex.addItem()
          .alignItems(.center)
          .define { flex in
            flex.addItem(imageView).width(100).height(100)
            flex.addItem().height(8)
            flex.addItem(titleLabel)
            flex.addItem().height(4)
            flex.addItem(descriptionLabel)
          }

        flex.addItem().grow(1)
        flex.addItem(confirmButton).height(56)
        flex.addItem().height(12)
      }
  }

  func bind(reactor: CongratulationsReactor) {
    confirmButton.rx.tap
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .map { Reactor.Action.confirm }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    reactor.pulse(\.$destination)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, destination in
        switch destination {
        case .main:
          owner.coordinator?.main()
        }
      }
      .disposed(by: disposeBag)
  }
}

fileprivate enum Const {
  static var navigationBarTitle: String { "가입완료" }
  static var title: String { "회원가입을 축하합니다" }
  static var description: String { "머니몽을 자유롭게 사용해보세요" }
  static var confirmTitle: String { "홈으로 돌아가기" }
}
