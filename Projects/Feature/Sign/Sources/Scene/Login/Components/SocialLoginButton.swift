import UIKit

import DesignSystem
import NetworkService

final class SocialLoginButton: UIButton {

  init(type: LoginType) {
    super.init(frame: .zero)
    setupView(type: type)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupView(type: LoginType) {
    layer.cornerRadius = 12
    clipsToBounds = true

    var configuration = UIButton.Configuration.filled()
    configuration.imagePadding = 10

    switch type {
    case .kakao:
      setImage(Images.kakaoButton, for: .normal)
      configuration.baseBackgroundColor = Colors.Yellow._1
      var attributedTitle = AttributedString(Const.kakaoButtonTitle)
      attributedTitle.foregroundColor = Colors.Black._1
      attributedTitle.font = Fonts.body._3
      configuration.attributedTitle = attributedTitle
      self.configuration = configuration
    case .apple:
      setImage(Images.appleButton, for: .normal)
      configuration.baseBackgroundColor = Colors.Black._1
      var attributedTitle = AttributedString(Const.appleButtonTitle)
      attributedTitle.foregroundColor = Colors.White._1
      attributedTitle.font = Fonts.body._4
      configuration.attributedTitle = attributedTitle
      self.configuration = configuration
    }
  }
}

fileprivate enum Const {
  static var kakaoButtonTitle: String { "카카오 로그인" }
  static var appleButtonTitle: String { "Apple로 로그인" }
}
