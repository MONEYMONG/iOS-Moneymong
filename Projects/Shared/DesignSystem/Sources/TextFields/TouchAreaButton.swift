import UIKit

final class TouchAreaButton: UIButton {
  private let dx: CGFloat
  private let dy: CGFloat

  init(dx: CGFloat, dy: CGFloat) {
    self.dx = dx
    self.dy = dy
    super.init(frame: .zero)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    if isHidden || !isUserInteractionEnabled || alpha < 0.01 {
      return nil
    }

    let expandedArea = self.bounds.insetBy(dx: dx, dy: dy)

    if expandedArea.contains(point) {
      return self
    }

    return super.hitTest(point, with: event)
  }

  override var isHighlighted: Bool {
    didSet { alpha = isHighlighted && !alpha.isNaN ? 0.5 : 1.0 }
  }
}
