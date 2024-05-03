import UIKit

import DesignSystem

final class ToolTipVC: UIViewController {

  private let topTooltip: ToolTip = {
    let tooltip = ToolTip(type: .top)
    tooltip.setTitle(with: "상단 좌측 팁")
    tooltip.setBackgroundColor(with: Colors.White._1)
    tooltip.setCorneradius(8)
    tooltip.setTipPadding(left: 10)
    tooltip.setFonts(with: Fonts.body._3)
    tooltip.setTitleColor(with: Colors.Blue._4)
    return tooltip
  }()

  private let centerTooltip: ToolTip = {
    let tooltip = ToolTip(type: .bottom)
    tooltip.setTitle(with: "중앙 하단 팁, 패딩없음")
    tooltip.setBackgroundColor(with: Colors.White._1)
    tooltip.setCorneradius(8)
    tooltip.setFonts(with: Fonts.body._3)
    tooltip.setTitleColor(with: Colors.Blue._4)
    return tooltip
  }()

  private let bottomTooltip: ToolTip = {
    let tooltip = ToolTip(type: .bottom)
    tooltip.setTitle(with: "하단 우측 팁")
    tooltip.setBackgroundColor(with: Colors.White._1)
    tooltip.setCorneradius(8)
    tooltip.setTipPadding(right: 10)
    tooltip.setFonts(with: Fonts.body._3)
    tooltip.setTitleColor(with: Colors.Blue._4)
    return tooltip
  }()

  private let centerView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemBlue
    return view
  }()

  init() {
    super.init(nibName: nil, bundle: nil)
    setupView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupView() {
    view.backgroundColor = Colors.Blue._2
    view.addSubview(centerView)
    view.addSubview(topTooltip)
    view.addSubview(centerTooltip)
    view.addSubview(bottomTooltip)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    centerView.pin.center().width(50)
    topTooltip.pin.hCenter().top(100)
    centerTooltip.pin.center()
    bottomTooltip.pin.hCenter().bottom(0)
  }
}
