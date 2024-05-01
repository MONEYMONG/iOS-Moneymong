import UIKit

import Utility
import DesignSystem

import PinLayout
import FlexLayout

final class ReceiptHeader: UICollectionReusableView, ReusableView {
  private let receiptLabel1: UILabel = {
    let v = UILabel()
    v.textColor = Colors.Gray._6
    v.text = "영수증 (최대 12장)"
    v.font = Fonts.body._2
    return v
  }()
  
  private let receiptLabel2: UILabel = {
    let v = UILabel()
    v.textColor = Colors.Blue._4
    v.numberOfLines = 0
    v.text = "*지출일 경우 영수증을 꼭 제출해주세요"
    v.font = Fonts.body._2
    return v
  }()
  
  private let rootContainer = UIView()
  
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    bounds.size.width = size.width
    flex.layout(mode: .adjustHeight)
    return frame.size
  }
  
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
      flex.addItem(receiptLabel1)
      flex.addItem(receiptLabel2)
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
}



