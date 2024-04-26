import UIKit

public final class MMButton: UIButton {
  
  public enum `Type` {
    case primary
    case secondary
    case disable
    case negative
    
    var titleColor: UIColor {
      switch self {
      case .primary: return Colors.White._1
      case .secondary: return Colors.Blue._4
      case .disable: return Colors.Gray._4
      case .negative: return Colors.Gray._5
      }
    }
    
    var backgroundColor: UIColor {
      switch self {
      case .primary: return Colors.Blue._4
      case .secondary: return Colors.Blue._1
      case .disable: return Colors.Gray._3
      case .negative: return Colors.Gray._2
      }
    }
  }
  
  private let rootContainer = UIView()
  
  private var type: `Type` {
    didSet {
      updateState()
    }
  }

  public init(title: String, type: `Type`) {
    self.type = type
    super.init(frame: .zero)
    updateState()
    setupView(with: title)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupView(with title: String) {
    clipsToBounds = true
    layer.cornerRadius = 12
    
    var attributedTitle = AttributedString(title)
    attributedTitle.font = Fonts.body._3
    
    var configuration = UIButton.Configuration.bordered()
    configuration.attributedTitle = attributedTitle
    configuration.baseForegroundColor = type.titleColor
    configuration.baseBackgroundColor = type.backgroundColor
    
    self.configuration = configuration
  }
  
  private func updateState() {
    isEnabled = type != .disable
    configuration?.baseForegroundColor = type.titleColor
    configuration?.baseBackgroundColor = type.backgroundColor
  }
}

extension MMButton {
  public func setState(_ type: `Type`) {
    self.type = type
  }
}
