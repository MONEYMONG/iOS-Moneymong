//
//  CategoryChip.swift
//  DesignSystem
//
//  Created by 이시원 on 10/13/25.
//

import UIKit

public final class CategoryChip: UIButton {
  public enum State {
    case selected
    case unselected
    case deletable
  }
  
  public var stateType: State
  private var initialWidth: CGFloat?
  
  public init(title: String, state: State = .unselected) {
    self.stateType = state
    super.init(frame: .zero)
    setupView(title: title)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    if initialWidth == nil {
      initialWidth = frame.width
    }
  }
  
  private func setupView(title: String) {
    backgroundColor = .white
    layer.cornerRadius = 18
    layer.borderWidth = 1.4
    
    var attributedTitle = AttributedString(title)
    attributedTitle.font = Fonts.body._3
    
    var configuration = UIButton.Configuration.bordered()
    configuration.attributedTitle = attributedTitle
    configuration.baseForegroundColor = Colors.Black._1
    configuration.contentInsets = .init(top: 9, leading: 12, bottom: 9, trailing: 12)
    configuration.imagePlacement = .trailing
    configuration.imagePadding = 2
    self.configuration = configuration
    clipsToBounds = true
    self.configuration?.baseBackgroundColor = Colors.White._1
    self.configuration?.baseForegroundColor = Colors.Gray._6
    
    updateState(stateType)
  }
  
  public func updateState(_ state: State) {
    layer.borderColor = state == .selected ? Colors.Blue._4.cgColor : Colors.Gray._3.cgColor
    if let initialWidth {
      frame = frame.updateWidth(state == .unselected ? initialWidth : initialWidth + 20)
    }
    switch state {
    case .selected:
      self.configuration?.image = Images.check?
        .resized(to: .init(width: 18, height: 18))
        .withRenderingMode(.alwaysTemplate)
      self.configuration?.imageColorTransformer = UIConfigurationColorTransformer { _ in return Colors.Blue._4 }
    case .unselected:
      self.configuration?.image = nil
    case .deletable:
      self.configuration?.image = Images.close?
        .resized(to: .init(width: 18, height: 18))
        .withRenderingMode(.alwaysTemplate)
      self.configuration?.imageColorTransformer = UIConfigurationColorTransformer { _ in return Colors.Gray._5 }
    }
    stateType = state
  }
}

private extension CGRect {
  func updateWidth(_ width: CGFloat) -> CGRect {
    return .init(
      x: origin.x,
      y: origin.y,
      width: width,
      height: height
    )
  }
}

private extension UIImage {
    func resized(to newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

#if DEBUG
import SwiftUI
struct MyViewPreview: PreviewProvider{
  static var previews: some View {
    UIViewPreview {
      CategoryChip(title: "회비", state: .deletable)
    }.previewLayout(.sizeThatFits)
  }
}
#endif
