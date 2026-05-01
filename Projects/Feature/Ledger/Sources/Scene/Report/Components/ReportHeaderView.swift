//
//  ReportHeaderView.swift
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

final class ReportHeaderView: UIView {
  private let rootContainer = UIView()
  private let cardContainer = UIView()
  
  private let titleLabel = UILabel()
  private let iconImageView = UIImageView()
  
  private let incomeCard = UIView()
  private let incomeTitleLabel = UILabel()
  private let incomeValueLabel = UILabel()
  
  private let expenseCard = UIView()
  private let expenseTitleLabel = UILabel()
  private let expenseValueLabel = UILabel()
  
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
    backgroundColor = .clear
    
    cardContainer.backgroundColor = .white
    cardContainer.layer.cornerRadius = 16
    cardContainer.layer.masksToBounds = true
    
    titleLabel.textColor = Colors.Blue._4
    titleLabel.font = Fonts.heading._5
    titleLabel.numberOfLines = 2

    
    iconImageView.image = Images.moneyAndPen
    
    incomeCard.backgroundColor = Colors.Gray._1
    incomeCard.layer.cornerRadius = 8
    
    incomeTitleLabel.text = "총 수입"
    incomeTitleLabel.textColor = Colors.Gray._6
    incomeTitleLabel.font = Fonts.body._2
    incomeTitleLabel.textAlignment = .center
    
    incomeValueLabel.textColor = UIColor.black
    incomeValueLabel.font = Fonts.heading._1
    incomeValueLabel.textAlignment = .center
    
    expenseCard.backgroundColor = Colors.Gray._1
    expenseCard.layer.cornerRadius = 8
    
    expenseTitleLabel.text = "총 지출"
    expenseTitleLabel.textColor = Colors.Gray._6
    expenseTitleLabel.font = Fonts.body._2
    expenseTitleLabel.textAlignment = .center
    
    expenseValueLabel.textColor = UIColor.black
    expenseValueLabel.font = Fonts.heading._1
    expenseValueLabel.textAlignment = .center
  }
  
  private func setupConstraints() {
    addSubview(rootContainer)
    
    rootContainer.flex.define { flex in
      flex.addItem(cardContainer)
        .padding(20, 24)
        .define { flex in
          flex.addItem().direction(.row).justifyContent(.spaceBetween).alignItems(.center).define { flex in
            flex.addItem().define { flex in
              flex.addItem(titleLabel).height(80).grow(1)
            }.grow(1)
            
            flex.addItem(iconImageView).width(80).height(80)
          }
          
          flex.addItem().direction(.row).marginTop(16).define { flex in
            flex.addItem(incomeCard).grow(1).define { flex in
              flex.addItem(incomeTitleLabel)
              flex.addItem(incomeValueLabel).marginTop(4).grow(1)
            }.height(68).padding(12)
            
            flex.addItem(expenseCard).grow(1).marginLeft(12).define { flex in
              flex.addItem(expenseTitleLabel)
              flex.addItem(expenseValueLabel).marginTop(4).grow(1)
            }.height(68).padding(12)
          }
        }
    }
  }
  
  func setContent(balance: String, income: String, expense: String) {
    titleLabel.text = "\(balance)원\n남아 있어요!"
    let attributedStr = NSMutableAttributedString(string: titleLabel.text!)
    attributedStr.addAttribute(.foregroundColor, value: Colors.Gray._10, range: (titleLabel.text! as NSString).range(of: "원\n남아 있어요!"))
    titleLabel.attributedText = attributedStr
    
    incomeValueLabel.text = "+\(income)원"
    expenseValueLabel.text = "-\(expense)원"
    layoutIfNeeded()
  }
}

#if DEBUG
import SwiftUI

struct ReportHeaderView_Previews: PreviewProvider {
  static var previews: some View {
    let view = ReportHeaderView()

    UIViewPreview {
      view
    }
    .onAppear {
      Fonts.registerFont()
      view.setContent(balance: "50,000", income: "100,000", expense: "50,000")
    }
  }
}
#endif
