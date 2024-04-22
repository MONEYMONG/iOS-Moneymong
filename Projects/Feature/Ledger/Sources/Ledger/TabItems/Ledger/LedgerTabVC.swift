import UIKit

import BaseFeature
import ReactorKit
import DesignSystem

final class LedgerTabVC: BaseVC, View {
  var disposeBag = DisposeBag()
  
  private let floatingButton = FloatingButton()
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }
  
  override func setupUI() {
    super.setupUI()
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    rootContainer.addSubview(floatingButton)
    floatingButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      floatingButton.bottomAnchor.constraint(equalTo: rootContainer.bottomAnchor, constant: -20),
      floatingButton.rightAnchor.constraint(equalTo: rootContainer.rightAnchor, constant: -20)
    ])
  }
  
  func bind(reactor: LedgerTabReactor) {
    
  }
}
