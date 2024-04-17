import UIKit

import DesignSystem

final class FloatingButtonVC: UIViewController {
  
  private let floatingButton = FloatingButton()
  private let label = UILabel()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    setupConstraints()
  }
  
  private func setupView() {
    view.backgroundColor = .white
    title = "FloatingButton"
    label.numberOfLines = 0
    label.font = .systemFont(ofSize: 20)
    label.text = """
      addScanAction, addWriteAction
      을 호출하여 버튼과 액션 바이딩
    """
    
    floatingButton.addScanAction {
      SnackBarManager.show(title: "ScanButton 탭")
    }
    
    floatingButton.addWriteAction {
      SnackBarManager.show(title: "Write버튼 탭")
    }
  }
  
  private func setupConstraints() {
    view.addSubview(floatingButton)
    view.addSubview(label)
    
    label.translatesAutoresizingMaskIntoConstraints = false
    floatingButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      floatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      floatingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
    
    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }
}
