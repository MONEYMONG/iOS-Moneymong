import UIKit

public final class FloatingButton: UIView {
  
  private let topButton: UIButton = {
    let v = UIButton()
    v.isHidden = true
    v.setBackgroundImage(Images.scanCircleFill, for: .normal)
    return v
  }()
  
  private let centerButton: UIButton = {
    let v = UIButton()
    v.isHidden = true
    v.setBackgroundImage(Images.pencilCircleFill, for: .normal)
    return v
  }()
  
  private let bottomButton: UIButton = {
    let v = UIButton()
    v.setBackgroundImage(Images.plusCircleFillGreen, for: .normal)
    return v
  }()
  
  private let stackView: UIStackView = {
    let v = UIStackView()
    v.translatesAutoresizingMaskIntoConstraints = false
    v.spacing = 0
    v.axis = .vertical
    v.distribution = .fillEqually
    return v
  }()
  
  private var isFold = true
  
  public init() {
    super.init(frame: .zero)
    
    setupUI()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    addSubview(stackView)
    stackView.addArrangedSubview(topButton)
    stackView.addArrangedSubview(centerButton)
    stackView.addArrangedSubview(bottomButton)
    
    bottomButton.addAction {
      self.toggleBottomButton()
      self.toggleFloatingButton()
    }
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
    
    [topButton, centerButton, bottomButton].forEach { button in
      NSLayoutConstraint.activate([
        button.widthAnchor.constraint(equalToConstant: 70),
        button.heightAnchor.constraint(equalToConstant: 70),
      ])
    }
  }
  
  private func toggleBottomButton() {
    let rotation = !isFold ? CGAffineTransform.identity : CGAffineTransform(rotationAngle: .pi / 4)
    
    UIView.animate(withDuration: 0.5) {
      self.bottomButton.transform = rotation
    }
  }
  
  private func toggleFloatingButton() {
    let buttons = [centerButton, topButton]
    
    if isFold {
      buttons.forEach { button in
        button.alpha = 0
        UIView.animate(withDuration: 0.3) {
          button.alpha = 1
          button.isHidden = false
        }
      }
    } else {
        buttons.forEach { button in
          UIView.animate(withDuration: 0.3) {
            button.alpha = 0
            button.isHidden = true
          }
        }
    }
    
    isFold.toggle()
  }
}

public extension FloatingButton {
  func addScanAction(_ action: @escaping () -> Void) {
    topButton.addAction { [weak self] in
      action()
      
      self?.toggleBottomButton()
      self?.toggleFloatingButton()
    }
  }
  
  func addWriteAction(_ action: @escaping () -> Void) {
    centerButton.addAction { [weak self] in
      action()
      
      self?.toggleBottomButton()
      self?.toggleFloatingButton()
    }
  }
}
