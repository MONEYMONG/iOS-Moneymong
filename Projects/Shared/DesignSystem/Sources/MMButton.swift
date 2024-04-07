import UIKit

extension MMButton {
  func setState(_ type: `Type`) {
    self.type = type
  }
}

public final class MMButton: UIButton {
  private let flexContainer = UIView()
  
  private var type: `Type` {
    didSet {
      updateState()
    }
  }

  public enum `Type` {
    case primary
    case secondary
    case disable
    case negative
    
    var titleColor: UIColor {
      switch self {
      case .primary:
        return Colors.White._1
      case .secondary:
        return Colors.Blue._4
      case .disable:
        return Colors.Gray._4
      case .negative:
        return Colors.Gray._5
      }
    }
    
    var backgroundColor: UIColor {
      switch self {
      case .primary:
        return Colors.Blue._4
      case .secondary:
        return Colors.Blue._1
      case .disable:
        return Colors.Gray._3
      case .negative:
        return Colors.Gray._2
      }
    }
  }

  public init(title: String, type: `Type`) {
    self.type = type
    super.init(frame: .zero)
    setTitle(title, for: .normal)
    
    setupView()
    setupContraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupView() {
    addSubview(self.flexContainer)
    titleLabel?.font = .systemFont(ofSize: 14)
    layer.cornerRadius = 12
    clipsToBounds = true
    
    setTitleColor(type.titleColor, for: .normal)
    backgroundColor = type.backgroundColor
  }

  private func setupContraints() {

  }
  
  private func updateState() {
    setTitleColor(type.titleColor, for: .normal)
    backgroundColor = type.backgroundColor
  }
}


