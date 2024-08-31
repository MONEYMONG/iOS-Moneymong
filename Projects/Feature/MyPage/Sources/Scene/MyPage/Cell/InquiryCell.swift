import UIKit

import Utility
import DesignSystem

final class InquiryCell: UITableViewCell, ReusableView {
  private let titleLabel: UILabel = {
    let v = UILabel()
    v.textColor = Colors.Gray._8
    v.font = Fonts.bold16
    v.setTextWithLineHeight(text: "머니몽에게\n자유롭게 문의 해보세요!", lineHeight: 24)
    v.numberOfLines = 2
    return v
  }()
  
  private let inquiryButton: UIButton = MMButton(title: "머니몽 팀에게 카톡하기", type: .secondary)
  
  private let rootContainer = UIView()
  
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    contentView.bounds.size.width = size.width
    contentView.flex.layout(mode: .adjustHeight)
    return contentView.frame.size
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupUI()
    setupConstraints()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    contentView.addSubview(rootContainer)
    selectionStyle = .none
  }
  
  private func setupConstraints() {
    rootContainer.flex
      .define { flex in
        flex.addItem()
          .direction(.row).define { flex in
            flex.addItem().padding(20, 16).define { flex in
              flex.addItem(titleLabel)
                .marginBottom(8)
              flex.addItem(inquiryButton).height(38)
            }
            .marginRight(10)
            flex.addItem(UIImageView(image: Images.mongInquiry))
          }
      }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
}
