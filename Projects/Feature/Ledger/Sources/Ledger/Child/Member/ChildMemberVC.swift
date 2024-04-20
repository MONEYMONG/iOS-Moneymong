import UIKit

import BaseFeature
import ReactorKit

final class ChildMemberVC: BaseVC, View {
  var disposeBag = DisposeBag()
  weak var coordinator: Coordinator?
  
  override func setupUI() {
    super.setupUI()
  }
  
  override func setupConstraints() {
    super.setupConstraints()
  }
  
  func bind(reactor: ChildMemberReactor) {
    
  }
}
