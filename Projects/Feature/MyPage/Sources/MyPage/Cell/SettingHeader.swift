import UIKit

import Utility
import DesignSystem

final class SettingHeader: UITableViewHeaderFooterView, ReusableView {
  
  private let titleLabel: UILabel = {
    let v = UILabel()
    v.textColor = Colors.Gray._10
    v.font = Fonts.body._4
    v.setTextWithLineHeight(text: "내설정", lineHeight: 24)
    return v
  }()
  
  private let rootContainer = UIView()
  
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    contentView.bounds.size.width = size.width
    contentView.flex.layout(mode: .adjustHeight)
    return contentView.frame.size
  }
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    
    setupUI()
    setupConstraints()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    contentView.addSubview(rootContainer)
  }
  
  private func setupConstraints() {
    rootContainer.flex.paddingBottom(16).define { flex in
      flex.addItem(titleLabel)
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
}
