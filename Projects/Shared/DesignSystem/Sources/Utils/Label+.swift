import UIKit

public extension UILabel {
  func setTextWithLineHeight(text: String?, lineHeight: CGFloat) {
    if let text = text {
      let style = NSMutableParagraphStyle()
      style.maximumLineHeight = lineHeight
      style.minimumLineHeight = lineHeight
      
      let attributes: [NSAttributedString.Key: Any] = [
        .paragraphStyle: style,
        .baselineOffset: (lineHeight - font.lineHeight) / 4
      ]
      
      self.attributedText = NSAttributedString(string: text,attributes: attributes)
    }
  }
}
