import UIKit

public class Tip: UIView {
  private let type: ToolTip.`Type`
  private var color: UIColor?

  init(type: ToolTip.`Type` = .bottom) {
    self.type = type
    super.init(frame: .zero)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func draw(_ rect: CGRect) {
    backgroundColor = .clear
    color?.setFill()

    switch type {
    case .top:
      drawTopTip(rect)
    case .bottom:
      drawBottomTip(rect)
    }
  }

  private func drawTopTip(_ rect: CGRect) {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 0, y: rect.maxY))
    path.addQuadCurve(
      to: CGPoint(x: rect.maxX, y: rect.maxY),
      controlPoint: CGPoint(x: rect.midX, y: rect.minY - 6)
    )
    path.close()
    path.fill()
  }

  private func drawBottomTip(_ rect: CGRect) {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 0, y: 0))
    path.addQuadCurve(
      to: CGPoint(x: rect.maxX, y: 0),
      controlPoint: CGPoint(x: rect.midX, y: rect.maxY + 6)
    )
    path.close()
    path.fill()
  }
}

extension Tip {
  func setColor(with: UIColor) {
    color = with
    setNeedsLayout()
  }
}
