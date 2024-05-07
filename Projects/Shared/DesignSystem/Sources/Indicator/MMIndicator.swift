import UIKit
import QuartzCore

public class MMIndicator: UIView {

  private let animationLayer: CALayer = {
    let layer = CALayer()
    layer.contents = Images.indicator?.cgImage
    layer.masksToBounds = true
    return layer
  }()

  var isAnimating: Bool = false
  var hidesWhenStopped: Bool = true

  public init(size: Int = 74) {
    let frame = CGRect(x: 0, y: 0, width: size, height: size)
    super.init(frame: frame)
    setupView(frame: frame)
  }

  @available(*, unavailable)
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupView(frame: CGRect) {
    animationLayer.frame = frame
    self.layer.addSublayer(animationLayer)
    addRotation(forLayer: animationLayer)
    pause(animationLayer)
    self.isHidden = true
  }

  private func addRotation(forLayer layer : CALayer) {
    let rotation: CABasicAnimation = CABasicAnimation(keyPath:"transform.rotation.z")

    rotation.duration = 1.0
    rotation.isRemovedOnCompletion = false
    rotation.repeatCount = HUGE
    rotation.fillMode = CAMediaTimingFillMode.forwards
    rotation.fromValue = NSNumber(value: 0.0)
    rotation.toValue = NSNumber(value: 3.14 * 2.0)

    layer.add(rotation, forKey: "rotate")
  }

  private func pause(_ layer: CALayer) {
    let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)

    layer.speed = 0.0
    layer.timeOffset = pausedTime

    isAnimating = false
  }

  private func resume(_ layer: CALayer) {
    let pausedTime: CFTimeInterval = layer.timeOffset

    layer.speed = 1.0

    let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
    layer.beginTime = timeSincePause

    isAnimating = true
  }

  public func startAnimating () {
    if isAnimating { return }

    if hidesWhenStopped {
      self.isHidden = false
    }
    resume(animationLayer)
  }

  public func stopAnimating () {
    if hidesWhenStopped {
      self.isHidden = true
    }
    pause(animationLayer)
  }
}
