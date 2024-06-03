import UIKit


final class HighlightCircleView: UIView {

  private let defaultColor: UIColor
  private let highlightColor: UIColor
  private let lineWidth: CGFloat

  init(
    defaultColor: UIColor,
    highlightColor: UIColor,
    lineWidth: CGFloat
  ) {
    self.defaultColor = defaultColor
    self.highlightColor = highlightColor
    self.lineWidth = lineWidth
    super.init(frame: .zero)
    backgroundColor = .clear
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext() else { return }

    // 선 두께 설정
    context.setLineWidth(lineWidth)

    // 원형 그리기
    let center = CGPoint(x: bounds.midX, y: bounds.midY)
    let radius = min(bounds.width, bounds.height) / 2 - 10

    // 2/3 부분 defaultColor
    context.setStrokeColor(defaultColor.cgColor)
    context.addArc(
      center: center,
      radius: radius,
      startAngle: 0,
      endAngle: 2 * .pi / 3,
      clockwise: true
    )
    context.strokePath()

    // 나머지 1/3 부분 highlightColor
    context.setStrokeColor(highlightColor.cgColor)
    context.addArc(
      center: center,
      radius: radius,
      startAngle: 2 * .pi / 3,
      endAngle: 2 * .pi,
      clockwise: true
    )
    context.strokePath()
  }
}
