//
//  MemberIncomeAndExpenseCell.swift
//  LedgerFeature
//
//  Created by 이시원 on 4/14/26.
//

import UIKit

import Utility
import DesignSystem
import BaseDomain

import FlexLayout
import PinLayout

final class MemberIncomeAndExpenseCell: UICollectionViewCell, ReusableView {
  private let rootContainer = UIView()
  
  private let avatarBackgroundView = UIView()
  private let avatarImageView = UIImageView()
  private let nameLabel = UILabel()
  
  private let incomeTitleLabel = UILabel()
  private let incomeAmountLabel = UILabel()
  private let incomeBadgeContainer = UIView()
  private let incomeBadgeLabel = UILabel()
  
  private let expenseTitleLabel = UILabel()
  private let expenseAmountLabel = UILabel()
  private let expenseBadgeContainer = UIView()
  private let expenseBadgeLabel = UILabel()
  
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
    
    avatarBackgroundView.layer.cornerRadius = avatarBackgroundView.bounds.width / 2
    incomeBadgeContainer.layer.cornerRadius = incomeBadgeContainer.bounds.height / 2
    expenseBadgeContainer.layer.cornerRadius = expenseBadgeContainer.bounds.height / 2
  }
  
  private func setupViews() {
    contentView.backgroundColor = .clear
    
    avatarBackgroundView.backgroundColor = Colors.SkyBlue._1
    avatarBackgroundView.layer.masksToBounds = true
    
    avatarImageView.image = Images.mong
    
    nameLabel.textColor = Colors.Gray._10
    nameLabel.font = Fonts.heading._1
    
    incomeTitleLabel.text = "수입"
    incomeTitleLabel.textColor = Colors.Gray._5
    incomeTitleLabel.font = Fonts.body._3
    
    incomeAmountLabel.textColor = Colors.Gray._6
    incomeAmountLabel.font = Fonts.body._3
    
    incomeBadgeContainer.backgroundColor = Colors.Blue._4
    incomeBadgeLabel.textColor = UIColor.white
    incomeBadgeLabel.font = Fonts.body._2
    
    expenseTitleLabel.text = "지출"
    expenseTitleLabel.textColor = Colors.Gray._5
    expenseTitleLabel.font = Fonts.body._3
    
    expenseAmountLabel.textColor = Colors.Gray._6
    expenseAmountLabel.font = Fonts.body._3
    
    expenseBadgeContainer.backgroundColor = Colors.Red._3
    expenseBadgeLabel.textColor = UIColor.white
    expenseBadgeLabel.font = Fonts.body._2
  }
  
  private func setupConstraints() {
    contentView.addSubview(rootContainer)
    
    rootContainer.flex.define { flex in
      flex.addItem().direction(.row).alignItems(.center).define { flex in
        flex.addItem(avatarBackgroundView)
          .width(32)
          .height(32)
          .justifyContent(.center)
          .define { flex in
            flex.addItem(avatarImageView).alignSelf(.center)
          }
        
        flex.addItem(nameLabel).marginLeft(8)
      }
      
      flex.addItem().direction(.row).alignItems(.center).marginTop(12).define { flex in
        flex.addItem(incomeTitleLabel)
        flex.addItem(incomeAmountLabel).marginLeft(4)
        flex.addItem(incomeBadgeContainer)
          .marginLeft(8)
          .width(41)
          .height(20)
          .alignItems(.center)
          .justifyContent(.center)
          .define { flex in
            flex.addItem(incomeBadgeLabel)
          }
      }
      
      flex.addItem().direction(.row).alignItems(.center).marginTop(12).define { flex in
        flex.addItem(expenseTitleLabel)
        flex.addItem(expenseAmountLabel).marginLeft(4)
        flex.addItem(expenseBadgeContainer)
          .marginLeft(8)
          .width(41)
          .height(20)
          .alignItems(.center)
          .justifyContent(.center)
          .define { flex in
            flex.addItem(expenseBadgeLabel)
          }
      }
    }
  }
  
  func setContent(
    name: String,
    incomeAmount: String,
    incomeRate: String,
    expenseAmount: String,
    expenseRate: String
  ) {
    nameLabel.text = name
    incomeAmountLabel.text = "+\(incomeAmount)원"
    incomeBadgeLabel.text = incomeRate
    expenseAmountLabel.text = "-\(expenseAmount)원"
    expenseBadgeLabel.text = expenseRate
    incomeAmountLabel.flex.markDirty()
    incomeBadgeLabel.flex.markDirty()
    expenseAmountLabel.flex.markDirty()
    expenseBadgeLabel.flex.markDirty()
    setNeedsLayout()
  }
}

#if DEBUG
import SwiftUI

struct MemberIncomeAndExpenseCell_Previews: PreviewProvider {
  static var previews: some View {
    let view = MemberIncomeAndExpenseCell()
    
    UIViewPreview {
      view
    }
    .onAppear {
      Fonts.registerFont()
    }
  }
}
#endif
