import UIKit

import DesignSystem

final class ButtonVC: UIViewController {
  
  private let button1 = MMButton(title: "dudu", type: .primary)
  private let button2 = MMButton(title: "dudu", type: .primary)
  private let button3 = MMButton(title: "dudu", type: .primary)
  private let segmentedControl: UISegmentedControl = {
    let v = UISegmentedControl(items: ["primary", "secondary", "disable", "negative"])
    v.selectedSegmentIndex = 0
    return v
  }()
  
  private let rootContainer = UIView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    setupConstraints()
  }
  
  private func setupView() {
    view.backgroundColor = .systemBackground
    title = "MMButton"
    
    let buttons = [button1, button2, button3]
    
    segmentedControl.setAction(UIAction(title: "Primary") { _ in
      buttons.forEach { $0.setState(.primary) }
    }, forSegmentAt: 0)
    
    segmentedControl.setAction(UIAction(title: "Secondary") { _ in
      buttons.forEach { $0.setState(.secondary) }
    }, forSegmentAt: 1)
    
    segmentedControl.setAction(UIAction(title: "Disable") { _ in
      buttons.forEach { $0.setState(.disable) }
    }, forSegmentAt: 2)
    
    segmentedControl.setAction(UIAction(title: "Negative") { _ in
      buttons.forEach { $0.setState(.negative) }
    }, forSegmentAt: 3)
  }
  
  private func setupConstraints() {
    view.addSubview(rootContainer)
    
    rootContainer.flex.justifyContent(.center).padding(20).define { flex in
      flex.addItem(button1).height(56).marginBottom(20)
      flex.addItem(button2).height(44).marginBottom(20)
      flex.addItem(button3).height(40).marginBottom(20)
      flex.addItem(segmentedControl).height(50)
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
}
