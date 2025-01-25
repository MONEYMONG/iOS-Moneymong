import UIKit

import DesignSystem
import BaseFeature
import ReactorKit
import SignFeatureInterface

final class SplashVC: BaseVC, View {
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
          let loginVC = DIContainer.shared.resolve(type: SignFactoryInterface.self).makeLogin()
          owner.navigationController?.pushViewController(loginVC, animated: false)
        case .main:
          NotificationCenter.default.post(name: .moveMain, object: nil)
        }
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$isUpdateAlert)
      .observe(on: MainScheduler.instance)
      .filter { $0 }
      .bind(with: self) { owner, value in
        owner.showAlert(title: "안정적인 머니몽 사용을 위해\n최신 버전으로 업데이트가 필요해요!", type: .onlyOkButton({
          if let url = URL(string: "itms-apps://itunes.apple.com/app/id6503661220"),
                       UIApplication.shared.canOpenURL(url)
          {
            UIApplication.shared.open(url) { result in
              if result {
                UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                  exit(0)
                }
              }
            }
          }
        }))
      }
      .disposed(by: disposeBag)

    rx.viewDidAppear
      .delay(.milliseconds(500), scheduler: MainScheduler.instance)
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
