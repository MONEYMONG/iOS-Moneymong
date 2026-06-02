//
//  ReportItem.swift
//  LedgerFeature
//
//  Created by 이시원 on 6/5/26.
//

import Foundation

import BaseDomain

public struct ReportItem: Equatable {
  public let totalIncome: String
  public let totalExpense: String
  public let totalBalance: String
  public let monthly: [MonthlyReportItem]
  
  public init(
    report: Report,
    formatter: ContentFormatter
  ) {
    self.totalIncome = formatter.convertToAmount(with: report.totalIncome) ?? "0"
    self.totalExpense = formatter.convertToAmount(with: report.totalExpense) ?? "0"
    self.totalBalance = formatter.convertToAmount(with: report.totalBalance) ?? "0"
    self.monthly = report.monthly.map { MonthlyReportItem(monthly: $0, formatter: formatter) }
  }
}

public struct MonthlyReportItem: Equatable {
  public let dateLabel: String
  public let month: Int
  public let income: String
  public let expense: String
  public let incomeShareOfPeriod: String
  public let expenseShareOfPeriod: String
  public let members: [MemberReportItem]
  public let categories: [CategoryReportItem]
  
  public init(
    monthly: MonthlyReport,
    formatter: ContentFormatter
  ) {
    self.dateLabel = "\(monthly.year). \(monthly.month)"
    self.month = monthly.month
    self.income = formatter.convertToAmount(with: monthly.income) ?? "0"
    self.expense = formatter.convertToAmount(with: monthly.expense) ?? "0"
    self.incomeShareOfPeriod = "\(Int(round(monthly.incomeShareOfPeriod * 100)))%"
    self.expenseShareOfPeriod = "\(Int(round(monthly.expenseShareOfPeriod * 100)))%"
    self.members = monthly.members.map { MemberReportItem(member: $0, formatter: formatter) }
    self.categories = monthly
      .categories.map { CategoryReportItem(category: $0, formatter: formatter) }
  }
}

public struct MemberReportItem: Equatable {
  public let nickname: String
  public let income: String
  public let expense: String
  public let incomeShare: String
  public let expenseShare: String
  
  public init(
    member: MemberReport,
    formatter: ContentFormatter
  ) {
    self.nickname = member.nickname
    self.income = formatter.convertToAmount(with: member.income) ?? "0"
    self.expense = formatter.convertToAmount(with: member.expense) ?? "0"
    self.incomeShare = "\(Int(round(member.incomeShare * 100)))%"
    self.expenseShare = "\(Int(round(member.expenseShare * 100)))%"
  }
}

public struct CategoryReportItem: Equatable {
  public let name: String
  public let income: String
  public let expense: String
  public let incomeShare: Double
  public let expenseShare: Double
  
  public init(
    category: CategoryReport,
    formatter: ContentFormatter
  ) {
    self.name = category.name
    self.income = formatter.convertToAmount(with: category.income) ?? "0"
    self.expense = formatter.convertToAmount(with: category.expense) ?? "0"
    self.incomeShare = category.incomeShare * 100
    self.expenseShare = category.expenseShare * 100
  }
}
