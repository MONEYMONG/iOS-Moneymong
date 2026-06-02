//
//  ReportVC.swift
//  LedgerFeature
//
//  Created by 이시원 on 4/17/26.
//

import UIKit

import BaseDomain
import BaseFeature
import DesignSystem
import Utility
import LedgerFeatureInterface

import ReactorKit
import PinLayout
import FlexLayout

final class ReportVC: BaseVC, View, UICollectionViewDelegateFlowLayout {
  var disposeBag = DisposeBag()
  var coordinator: LedgerCoordinator?
  
  private let scrollView = UIScrollView()
  private let contentView = UIView()
  private let headerView = ReportHeaderView()
  private let dateSelectionView = UIView()
  private let currentDateLabel = UILabel()
  private let leftArrowButton = UIButton()
  private let rightArrowButton = UIButton()
  private let monthryContainer = UIView()
  private let incomeCardView = MonthCardView()
  private let expenseCardView = MonthCardView()
  private let memberCollectionView = ReportInfoCollectionView(cellHeight: 96, spacing: 24)
  private let lineSegmentedControl = {
    let v = MMLineTabs(items: ["지출", "수입"])
    v.selectedSegmentIndex = 0
    return v
  }()
  
  private let categoriesGraphView = CategoriesGraphView()
  private let categoriesInfoCollectionView = ReportInfoCollectionView(cellHeight: 46, spacing: 15)
  
  private let progressView = UIView()
  private let progressIndicator = MMIndicator()
  private let emptyView = ReportEmptyView()
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    scrollView.contentSize = contentView.frame.size
  }
  
  override func setupPin() {
    rootContainer.pin
      .top(view.pin.safeArea.top)
      .bottom()
      .left()
      .right()
  }
  
  override func setupUI() {
    super.setupUI()
    scrollView.bounces = false
    memberCollectionView.delegate = self
    title = "레포트"
    view.backgroundColor = Colors.Gray._1
    
    currentDateLabel.textColor = Colors.Gray._10
    currentDateLabel.font = Fonts.heading._5
    currentDateLabel.text = " "
    currentDateLabel.textAlignment = .center

    
    leftArrowButton.setImage(Images.chevronLeft, for: .normal)
    rightArrowButton.setImage(Images.chevronRight, for: .normal)
    memberCollectionView.register(MemberIncomeAndExpenseCell.self)
    categoriesInfoCollectionView.register(CategoryInfoCell.self)
    
    lineSegmentedControl.selectedSegmentIndex = 0
    progressView.isHidden = true
    emptyView.isHidden = true
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    rootContainer.flex.define { flex in
      flex.addItem(scrollView).shrink(1).define() { flex in
        flex.addItem(contentView).define { flex in
          flex.addItem().define { flex in
            flex.addItem(headerView)
              .marginHorizontal(20)
              .marginBottom(16)
          }.backgroundColor(Colors.Gray._1)
          
          flex.addItem().define { flex in
            flex.addItem(dateSelectionView).direction(.row).alignItems(.center).define { flex in
              flex.addItem(leftArrowButton).size(20).marginRight(4)
              flex.addItem(currentDateLabel).marginRight(4).width(100)
              flex.addItem(rightArrowButton).size(20)
            }.marginBottom(8)
            flex.addItem().define { flex in
              flex.addItem(monthryContainer).define { flex in
                flex.addItem().direction(.row).define { flex in
                  flex.addItem(incomeCardView).grow(1)
                  flex.addItem(expenseCardView).grow(1).marginLeft(12)
                }
                flex.addItem().define { flex in
                  flex.addItem(UILabel().text("멤버별로 얼마나 쓰고 있을까?", font: Fonts.heading._4, color: Colors.Gray._10))
                  flex.addItem(memberCollectionView).marginTop(16)
                }.marginVertical(32)
                flex.addItem().define { flex in
                  flex.addItem(UILabel().text("카테고리별 이만큼 사용하고 있어요", font: Fonts.heading._4, color: Colors.Gray._10))
                  flex.addItem(lineSegmentedControl).height(36).marginTop(8)
                  flex.addItem(categoriesGraphView).marginTop(20)
                  flex.addItem(categoriesInfoCollectionView).marginTop(24)
                }
              }
              flex.addItem(progressView)
                .backgroundColor(.white)
                .position(.absolute)
                .top(0)
                .left(0)
                .right(0)
                .bottom(0)
                .alignItems(.center)
                .justifyContent(.center)
                .define { flex in
                  flex.addItem(progressIndicator)
                }
              
              flex.addItem(emptyView)
                .backgroundColor(.white)
            }
          }
          
          .padding(20, 16)
        }
      }
    }
    .backgroundColor(.white)
  }
  
  func bind(reactor: ReportReactor) {
    bindState(reactor: reactor)
    bindAction(reactor: reactor)
  }
  
  private func bindAction(reactor: ReportReactor) {
    setRightItem(.closeBlack)
    navigationItem.rightBarButtonItem?.rx.tap
      .bind(with: self) { owner, _ in
        owner.dismiss(animated: true)
      }
      .disposed(by: disposeBag)
    
    rx.viewWillAppear
      .map { Reactor.Action.requestReport }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    lineSegmentedControl.rx.selectedSegmentIndex
      .do (onNext: { [weak self] _ in
        guard let self else { return }
        lineSegmentedControl.setNeedsLayout()
      })
      .map { Reactor.Action.changeSegment($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    leftArrowButton.rx.tap
      .map { Reactor.Action.changePageIndex(-1) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    rightArrowButton.rx.tap
      .map { Reactor.Action.changePageIndex(1) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  private func bindState(reactor: ReportReactor) {
    reactor.pulse(\.$error)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, error in
        AlertsManager.show(title: error.errorTitle, subTitle: error.localizedDescription, type: .onlyOkButton())
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$reportItem)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, report in
        owner.headerView.setContent(
          balance: report.totalBalance,
          income: report.totalIncome,
          expense: report.totalExpense
        )
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$currentMonthly)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, monthly in
        owner.currentDateLabel.text = monthly.dateLabel
        owner.incomeCardView.setContent(month: monthly.month, value: monthly.income, description: monthly.incomeShareOfPeriod, type: .income)
        owner.expenseCardView.setContent(month: monthly.month, value: monthly.expense, description: monthly.expenseShareOfPeriod, type: .expense)
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$memberReports)
      .observe(on: MainScheduler.instance)
      .do { [weak self] in
        guard let self else { return }
        let height = memberCollectionView.getHeight(cellCount: $0.count)
        memberCollectionView.flex.height(height).markDirty()
        let scrollOffest = scrollView.contentOffset
        rootContainer.flex.layout(mode: .adjustHeight)
        scrollView.setContentOffset(scrollOffest, animated: false)
      }
      .do { [weak self] in
        guard let self else { return }
        if $0.isEmpty {
          emptyView.isHidden = false
          monthryContainer.isHidden = true
          emptyView.flex.isIncludedInLayout(true).markDirty()
          monthryContainer.flex.isIncludedInLayout(false).markDirty()
        } else {
          monthryContainer.isHidden = false
          emptyView.isHidden = true
          emptyView.flex.isIncludedInLayout(false).markDirty()
          monthryContainer.flex.isIncludedInLayout(true).markDirty()
        }
      }
      .bind(to: memberCollectionView.rx.items) { view, index, model in
        let cell = view.dequeueCell(MemberIncomeAndExpenseCell.self, for: IndexPath(row: index, section: 0))
        cell.setContent(name: model.nickname, incomeAmount: model.income, incomeRate: model.incomeShare, expenseAmount: model.expense, expenseRate: model.expenseShare)
        return cell
      }
      .disposed(by: disposeBag)
    
    Observable.combineLatest(
      reactor.pulse(\.$categoryReports),
      reactor.pulse(\.$segmentIndex)
    )
    .observe(on: MainScheduler.instance)
    .bind(with: self) { owner, value in
      let (categoryReports, index) = value
      owner.categoriesGraphView.setContent(
        month: reactor.currentState.currentMonthly?.month ?? 0,
        categoryReports: categoryReports,
        type: index == 1 ? .income : .expense
      )
    }
    .disposed(by: disposeBag)
    
    Observable.combineLatest(
      reactor.pulse(\.$categoryReports),
      reactor.pulse(\.$segmentIndex)
    )
    .observe(on: MainScheduler.instance)
    .do { [weak self] categoryReports, _ in
      guard let self else { return }
      if categoryReports.count > 3 {
        let height = categoriesInfoCollectionView.getHeight(cellCount: categoryReports.count - 3)
        
        categoriesInfoCollectionView.isHidden = false
        categoriesInfoCollectionView.flex.height(height).markDirty()
      } else {
        categoriesInfoCollectionView.isHidden = true
      }
      let scrollOffest = scrollView.contentOffset
      rootContainer.flex.layout(mode: .adjustHeight)
      scrollView.setContentOffset(scrollOffest, animated: false)
    }
    .filter { categoryReports, _ in
      categoryReports.count > 3
    }
    .map { categoryReports, index in
      Array(categoryReports[3..<categoryReports.endIndex])
        .map { (reprot: $0, index: index) }
    }
    .bind(to: categoriesInfoCollectionView.rx.items) { view, index, model in
      let (report, index) = model
      let cell = view.dequeueCell(CategoryInfoCell.self, for: IndexPath(row: index, section: 0))
      cell.setContent(
        categoryReport: report,
        type: index == 0 ? .expense : .income
      )
      return cell
    }
    .disposed(by: disposeBag)
    
    reactor.pulse(\.$isLoading)
      .map { isLoading in
        reactor.currentState.report == nil && isLoading
      }
      .bind(to: rx.isLoading)
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$isShownMonthlyProgress)
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, isShown in
        if isShown {
          owner.progressView.isHidden = false
          owner.progressIndicator.startAnimating()
          owner.leftArrowButton.isEnabled = false
        } else {
          owner.progressView.isHidden = true
          owner.progressIndicator.stopAnimating()
          owner.leftArrowButton.isEnabled = true
        }
        owner.view.setNeedsLayout()
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$isRightButtonEnabled)
      .observe(on: MainScheduler.instance)
      .bind(to: rightArrowButton.rx.isEnabled)
      .disposed(by: disposeBag)
  }
}

