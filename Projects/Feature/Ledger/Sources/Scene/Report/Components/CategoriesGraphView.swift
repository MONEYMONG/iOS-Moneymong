//
//  CategoriesGraphView.swift
//  LedgerFeature
//
//  Created by 이시원 on 4/15/26.
//

import UIKit

import DesignSystem
import BaseDomain

import RxCocoa
import RxSwift
import PinLayout
import FlexLayout

final class CategoriesGraphView: UIView {
  enum `Type` {
    case income
    case expense
  }
  private let rootContainer = UIView()
  
  private let titleLabel = UILabel()
  private let barsStackView = UIStackView()
  
  private var tempParameters: (
    month: Int,
    categoryReports: [CategoryReportItem],
    type: `Type`
  )? = nil
  
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
    titleLabel.font = Fonts.heading._1
    titleLabel.textColor = Colors.Gray._10
    titleLabel.numberOfLines = 2
    titleLabel.text = " \n "
    
    barsStackView.alignment = .bottom
    barsStackView.distribution = .fillEqually
  }
  
  private func setupConstraints() {
    addSubview(rootContainer)
    
    rootContainer.flex.define { flex in
      flex.addItem(titleLabel)
        .marginBottom(6)
        .height(50)
      
      flex.addItem(barsStackView)
        .height(350)
        .marginHorizontal(33)
    }
  }
  
  func setContent(month: Int, categoryReports: [CategoryReportItem], type: `Type`) {
    
    if tempParameters?.month == month,
       tempParameters?.type == type,
       tempParameters?.categoryReports == categoryReports {
      return
    }
    
    tempParameters = (month, categoryReports, type)
    
    let categories = Array(categoryReports.prefix(3))
    
    // Choose fields and wording based on type
    let isIncome = (type == .income)
    
    if isIncome {
      titleLabel.text = "\(month)월 동안\n\(categories.max(by: { $0.income < $1.income })?.name ?? "")에서 수입이 가장 많아요"
    } else {
      titleLabel.text = "\(month)월 동안\n\(categories.max(by: { $0.expense < $1.expense })?.name ?? "")에서 지출이 가장 많아요"
    }
    
    guard let text = titleLabel.text else { return }
    let attributedStr = NSMutableAttributedString(string: text)

    let startKeyword = "동안\n"
    let endKeyword = "에서"

    if let startRange = text.range(of: startKeyword),
       let endRange = text.range(of: endKeyword) {
        
        let startIndex = startRange.upperBound
        let endIndex = endRange.lowerBound
        
        let targetRange = NSRange(startIndex..<endIndex, in: text)
        
        attributedStr.addAttribute(
            .foregroundColor,
            value: Colors.Blue._4,
            range: targetRange
        )
    }

    titleLabel.attributedText = attributedStr
    
    barsStackView.arrangedSubviews.forEach {
      barsStackView.removeArrangedSubview($0)
      $0.removeFromSuperview()
    }
    
    // Sample colors for bars
    let barColors: [UIColor] = [
      Colors.Blue._4,
      Colors.Blue._3,
      Colors.SkyBlue._1
    ]
    
    let minBarHeight: CGFloat = 20
    let maxBarHeight: CGFloat = 174
    var barItems: [(NSLayoutConstraint, CGFloat)] = []
    
    if categories.count == 1 {
      let onlyCategory = categories[0]
      let amount = isIncome ? onlyCategory.income : onlyCategory.expense
      let height = amount == "0" ? 0 : maxBarHeight
      let color = barColors[0 % barColors.count]
      let (bar, constraint) = createCategoryBar(
        name: onlyCategory.name,
        amount: amount,
        percent: Int(isIncome ? onlyCategory.incomeShare : onlyCategory.expenseShare),
        barColor: color
      )
      
      barsStackView.addArrangedSubview(bar)
      barItems.append((constraint, height))
    } else {
      for (index, category) in categories.enumerated() {
        let share = isIncome ? category.incomeShare : category.expenseShare
        let height = minBarHeight + (maxBarHeight - minBarHeight) * share / 100
        let percentValue = Int(share)
        let color = barColors[index % barColors.count]
        let (bar, constraint) = createCategoryBar(
          name: category.name,
          amount: isIncome ? category.income : category.expense ,
          percent: percentValue,
          barColor: color
        )
        barsStackView.addArrangedSubview(bar)
        barItems.append((constraint, height))
      }
    }
    // Animate heights
    self.layoutIfNeeded()
    UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
      for (constraint, targetHeight) in barItems {
        constraint.constant = targetHeight
      }
      self.layoutIfNeeded()
    })
  }
  
  private func createCategoryBar(name: String, amount: String, percent: Int, barColor: UIColor) -> (UIStackView, NSLayoutConstraint) {
    let amountLabel = UILabel()
    amountLabel.text = "\(amount)원"
    amountLabel.font = Fonts.heading._1
    amountLabel.textColor = Colors.Gray._10
    amountLabel.textAlignment = .center

    let barView = UIView()
    barView.backgroundColor = barColor
    barView.layer.cornerRadius = 8
    barView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    barView.translatesAutoresizingMaskIntoConstraints = false
    let heightConstraint = barView.heightAnchor.constraint(equalToConstant: 0)
    NSLayoutConstraint.activate([
        heightConstraint,
        barView.widthAnchor.constraint(equalToConstant: 44)
    ])

    let nameLabel = UILabel()
    nameLabel.text = name
    nameLabel.font = Fonts.body._3
    nameLabel.textColor = Colors.Gray._10
    nameLabel.textAlignment = .center

    let percentLabel = UILabel()
    percentLabel.text = "\(percent)%"
    percentLabel.font = Fonts.caption
    percentLabel.textColor = Colors.Gray._4
    percentLabel.textAlignment = .center

    let stack = UIStackView(arrangedSubviews: [amountLabel, barView, nameLabel, percentLabel])
    stack.axis = .vertical
    stack.alignment = .center
    stack.spacing = 8
    stack.translatesAutoresizingMaskIntoConstraints = false
    return (stack, heightConstraint)
  }
}
