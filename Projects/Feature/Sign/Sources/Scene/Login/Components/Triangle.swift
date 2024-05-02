import UIKit

final class Triangle: UIView {
  init() {
    super.init(frame: .zero)
    setupTriangle()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupTriangle()
  }

  private func setupTriangle() {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 0, y: 10))
    path.addLine(to: CGPoint(x: 6, y: 0))
    path.addLine(to: CGPoint(x: 12, y: 10))
    path.close()

    let shapeLayer = CAShapeLayer()
    shapeLayer.path = path.cgPath
    shapeLayer.fillColor = UIColor.white.cgColor
//    shapeLayer.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 1)
    layer.addSublayer(shapeLayer)
  }
}
