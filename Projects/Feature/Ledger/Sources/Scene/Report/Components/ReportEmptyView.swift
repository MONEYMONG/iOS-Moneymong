//
//  ReportEmptyView.swift
//  LedgerFeature
//
//  Created by 이시원 on 6/19/26.
//

import UIKit

import DesignSystem

import RxCocoa
import RxSwift
import PinLayout
import FlexLayout

final class ReportEmptyView: UIView {
  private let rootContainer = UIView()
 
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupViews()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    setupViews()
    setupConstraints()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
  
  private func setupViews() {
    backgroundColor = .white
  }
  
  private func setupConstraints() {
    addSubview(rootContainer)
    
    rootContainer.flex.define { flex in
      flex.addItem()
        .alignItems(.center)
        .justifyContent(.center)
        .height(400)
        .define { flex in
        flex.addItem(UIImageView(image: Images.mongPassNot))
          .size(100)
        flex.addItem(UILabel().text("작성된 내역이 없어요", font: Fonts.body._3, color: Colors.Gray._5))
      }
    }
  }
}

#if DEBUG
import SwiftUI

struct ReportEmptyView_Previews: PreviewProvider {
  static var previews: some View {
    let view = ReportEmptyView()

    UIViewPreview {
      view
    }
    .onAppear {
      Fonts.registerFont()
    }
  }
}
#endif
