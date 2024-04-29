import UIKit

import Utility
import DesignSystem

import PinLayout
import FlexLayout

final class DocumentHeader: UICollectionReusableView, ReusableView {
  private let documentLabel: UILabel = {
    let v = UILabel()
    v.textColor = Colors.Gray._6
    v.text = "증빙 자료 (최대 12장)"
    v.font = Fonts.body._2
    return v
  }()
  
  private let rootContainer = UIView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupConstraints()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    addSubview(rootContainer)
  }
  
  private func setupConstraints() {
    rootContainer.flex.define { flex in
      flex.addItem(documentLabel)
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
}
