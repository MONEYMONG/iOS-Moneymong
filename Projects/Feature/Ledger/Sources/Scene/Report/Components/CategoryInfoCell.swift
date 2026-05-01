//
//  CategoryInfoCell.swift
//  LedgerFeature
//
//  Created by 이시원 on 4/24/26.
//

import UIKit

import Utility
import DesignSystem
import BaseDomain

import FlexLayout
import PinLayout

final class CategoryInfoCell: UICollectionViewCell, ReusableView {
  enum `Type` {
    case income
    case expense
  }
  private let rootContainer = UIView()
  
  private let nameLabel = UILabel()
  private let percentLabel = UILabel()
  private let priceLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupViews()
    setupConstraints()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
  
  private func setupViews() {
    contentView.backgroundColor = .clear
    
    nameLabel.text = "회비"
    nameLabel.textColor = Colors.Gray._7
    nameLabel.font = Fonts.heading._1
    
    priceLabel.text = "10,000원"
    nameLabel.textColor = Colors.Gray._7
    nameLabel.font = Fonts.heading._1
    
    percentLabel.text = "10%"
    percentLabel.textColor = Colors.Gray._4
    percentLabel.font = Fonts.body._3
  }
  
  private func setupConstraints() {
    contentView.addSubview(rootContainer)
    
    rootContainer.flex.define { flex in
      flex.addItem().direction(.row).define { flex in
        flex.addItem(nameLabel).grow(1)
        flex.addItem(priceLabel)
      }.marginBottom(6)
      flex.addItem(percentLabel)
    }
  }
  
  func setContent(categoryReport: CategoryReportItem, type: `Type`) {
    nameLabel.text = categoryReport.name
    priceLabel.text = type == .income ? "\(categoryReport.income)원" : "\(categoryReport.expense)원"
    percentLabel.text = type == .income ? "\(Int(categoryReport.incomeShare))%" : "\(Int(categoryReport.expenseShare))%"
    
    nameLabel.flex.markDirty()
    priceLabel.flex.markDirty()
    percentLabel.flex.markDirty()
    setNeedsLayout()
  }
}

#if DEBUG
import SwiftUI

struct CategoryInfoCell_Previews: PreviewProvider {
  static var previews: some View {
    let view = CategoryInfoCell()
    
    UIViewPreview {
      view
    }
    .onAppear {
      Fonts.registerFont()
    }
  }
}
#endif
