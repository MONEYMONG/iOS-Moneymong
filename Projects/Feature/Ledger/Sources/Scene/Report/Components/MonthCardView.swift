//
//  MonthCardView.swift
//  LedgerFeature
//
//  Created by 이시원 on 4/12/26.
//

import UIKit

import DesignSystem

import RxCocoa
import RxSwift
import PinLayout
import FlexLayout

final class MonthCardView: UIView {
  enum `Type` {
    case income
    case expense
  }
  
  private let rootContainer = UIView()
  private let cardContainer = UIView()
  
  private let titleLabel = UILabel()
  private let valueLabel = UILabel()
  private let descriptionLabel = UILabel()
  
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
    cardContainer.backgroundColor = Colors.Gray._1
    cardContainer.layer.cornerRadius = 12
    
    titleLabel.textColor = Colors.Blue._4
    titleLabel.font = Fonts.body._2
    
    valueLabel.textColor = Colors.Gray._10
    valueLabel.font = Fonts.heading._3
    
    descriptionLabel.textColor = Colors.Gray._6
    descriptionLabel.font = Fonts.body._2
  }
  
  private func setupConstraints() {
    addSubview(rootContainer)
    
    rootContainer.flex.define { flex in
      flex.addItem(cardContainer)
        .height(102)
        .justifyContent(.center)
        .paddingHorizontal(16)
        .define { flex in
          flex.addItem(titleLabel).height(18)
          flex.addItem(valueLabel).marginTop(6).height(28)
          flex.addItem(descriptionLabel).marginTop(10).height(18)
        }
    }
  }
  
  func setContent(month: Int, value: String, description: String, type: `Type`) {
    titleLabel.text = "\(month)월 \(type == .income ? "수입" : "지출")"
    valueLabel.text = "\(type == .income ? "+" : "-")\(value)원"
    descriptionLabel.text = "총 수입의 \(description)를 차지"
  }
}

#if DEBUG
import SwiftUI

struct MonthCardView_Previews: PreviewProvider {
  static var previews: some View {
    let view = MonthCardView()
    
    UIViewPreview {
      view
    }
    .onAppear {
      Fonts.registerFont()
    }
  }
}
#endif
