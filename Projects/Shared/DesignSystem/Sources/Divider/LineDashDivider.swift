import UIKit

public final class LineDashDivider: UIView {
  public override func draw(_ rect: CGRect) {
    let layer = CAShapeLayer()
    layer.strokeColor = Colors.Gray._3.cgColor
    layer.lineDashPattern = [4, 4]

    let path = UIBezierPath()
    let point1 = CGPoint(x: bounds.minX, y: bounds.midY)
    let point2 = CGPoint(x: bounds.maxX, y: bounds.midY)

    path.move(to: point1)
    path.addLine(to: point2)

    layer.path = path.cgPath
    self.layer.addSublayer(layer)
  }
}
