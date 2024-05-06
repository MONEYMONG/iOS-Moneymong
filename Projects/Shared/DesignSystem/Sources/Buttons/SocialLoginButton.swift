import UIKit

public class SocialLoginButton: UIButton {

  public enum `Type` {
    case apple
    case kakao

    var image: UIImage? {
      switch self {
      case .apple: Images.appleButton
      case .kakao: Images.kakaoButton
      }
    }

    var title: AttributedString {
      switch self {
      case .apple: 
        var string = AttributedString(Const.appleButtonTitle)
        string.foregroundColor = Colors.White._1
        string.font = Fonts.body._4
        return string
      case .kakao:
        var string = AttributedString(Const.kakaoButtonTitle)
        string.foregroundColor = Colors.Black._1
        string.font = Fonts.body._3
        return string
      }
    }

    var backgroundColor: UIColor {
      switch self {
      case .apple: Colors.Black._1
      case .kakao: Colors.Yellow._1
      }
    }
  }

  public init(type: `Type`) {
    super.init(frame: .zero)
    setupView(type: type)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupView(type: `Type`) {
    layer.cornerRadius = 12
    clipsToBounds = true

    setImage(type.image, for: .normal)
    var configuration = UIButton.Configuration.filled()
    configuration.baseBackgroundColor = type.backgroundColor
    configuration.imagePadding = 10
    configuration.attributedTitle = type.title
    self.configuration = configuration
  }
}

fileprivate enum Const {
  static var kakaoButtonTitle: String { "카카오 로그인" }
  static var appleButtonTitle: String { "Apple로 로그인" }
}
