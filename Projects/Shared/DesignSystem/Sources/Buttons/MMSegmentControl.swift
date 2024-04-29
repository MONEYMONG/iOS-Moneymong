import UIKit

import FlexLayout
import PinLayout

public final class MMSegmentControl: UIView {
  
  public enum `Type` {
    case capsule // 전체, 지출, 수입
    case round // 지출, 수입 or 동아리, 학생회
  }
  
  private let titles: [String]
  private let type: `Type`
  private let rootContainer = UIView()
  
  private let button1 = UIButton()
  private let button2 = UIButton()
  private let button3 = UIButton()
  private let button4 = UIButton()
  private let button5 = UIButton()
  
  @Published public var selectedIndex: Int = 0 {
    didSet {
      if allButtons.indices.contains(selectedIndex) {
        selection(with: allButtons[selectedIndex])
      }
    }
  }
  
  private var allButtons: [UIButton] {
    return [button1, button2, button3, button4, button5]
  }
  
  public init(titles: [String], type: Type) {
    self.titles = titles
    self.type = type
    super.init(frame: .zero)
    
    setupView()
    setupConstraints()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
  
  private func setupView() {
    backgroundColor = .white
    
    zip(titles, allButtons).forEach { (title, button) in
      var attributedTitle = AttributedString(title)
      attributedTitle.font = type == .capsule ? Fonts.body._2 : Fonts.body._3
      
      var configuration = UIButton.Configuration.bordered()
      configuration.attributedTitle = attributedTitle
      configuration.baseForegroundColor = Colors.Black._1
      
      button.configuration = configuration
      button.clipsToBounds = true
      button.layer.cornerRadius = type == .capsule ? 12 : 8
      button.layer.borderWidth = 1
      button.configuration?.baseBackgroundColor = Colors.White._1
      button.configuration?.baseForegroundColor = Colors.Gray._5
      button.layer.borderColor = Colors.Gray._3.cgColor
    }
    
    allButtons.enumerated().forEach { (index, button) in
      button.addAction { [weak self] in
        guard let self else { return }

        selectedIndex = index
        allButtons.forEach {
          self.unselection(with: $0)
        }
        selection(with: button)
      }
    }
  }
  
  private func setupConstraints() {
    addSubview(rootContainer)
    
    rootContainer.flex.define { flex in
      flex.addItem().direction(.row).define { flex in
        switch type {
        case .capsule: // 3개 (Capsule)
          flex.addItem(button1).width(50).height(24).marginRight(8)
          flex.addItem(button2).width(50).height(24).marginRight(8)
          flex.addItem(button3).width(50).height(24)
        case .round:
          flex.addItem(button1).height(40).grow(1).marginRight(10)
          flex.addItem(button2).height(40).grow(1).marginRight(10)
          
          if titles.count >= 3 {
            flex.addItem(button3).height(40).grow(1)
          }
        }
      }
      
      if type == .round && titles.count == 5 {
        flex.addItem().direction(.row).define { flex in
          flex.addItem(button4).height(40).grow(1).basis(0).marginRight(10)
          flex.addItem(button5).height(40).grow(1).basis(0).marginRight(10)
          flex.addItem(UIView()).height(40).grow(1).basis(0)
        }
        .marginTop(12)
      }
    }
  }
  
  private func selection(with button: UIButton) {
    button.configuration?.baseBackgroundColor = Colors.Blue._4
    button.configuration?.baseForegroundColor = Colors.White._1
    button.layer.borderColor = Colors.Blue._4.cgColor
  }
  
  private func unselection(with button: UIButton) {
    button.configuration?.baseBackgroundColor = Colors.White._1
    button.configuration?.baseForegroundColor = Colors.Gray._5
    button.layer.borderColor = Colors.Gray._3.cgColor
  }
}
