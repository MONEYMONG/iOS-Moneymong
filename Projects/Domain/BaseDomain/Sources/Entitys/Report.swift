import Foundation

public struct Report: Equatable {
  public let agencyId: Int
  public let agencyName: String
  public let period: PeriodInfo
  public let totalIncome: Int
  public let totalExpense: Int
  public let totalBalance: Int
  public let monthly: [MonthlyReport]
  
  public init(
    agencyId: Int,
    agencyName: String,
    period: PeriodInfo,
    totalIncome: Int,
    totalExpense: Int,
    totalBalance: Int,
    monthly: [MonthlyReport]
  ) {
    self.agencyId = agencyId
    self.agencyName = agencyName
    self.period = period
    self.totalIncome = totalIncome
    self.totalExpense = totalExpense
    self.totalBalance = totalBalance
    self.monthly = monthly
  }
  
  public func copyWith(
    agencyId: Int? = nil,
    agencyName: String? = nil,
    period: PeriodInfo? = nil,
    totalIncome: Int? = nil,
    totalExpense: Int? = nil,
    totalBalance: Int? = nil,
    monthly: [MonthlyReport]? = nil
  ) -> Report {
    return Report(
      agencyId: agencyId ?? self.agencyId,
      agencyName: agencyName ?? self.agencyName,
      period: period ?? self.period,
      totalIncome: totalIncome ?? self.totalIncome,
      totalExpense: totalExpense ?? self.totalExpense,
      totalBalance: totalBalance ?? self.totalBalance,
      monthly: monthly ?? self.monthly
    )
  }
}

public struct PeriodInfo: Equatable {
  public let startYear: Int
  public let startMonth: Int
  public let endYear: Int
  public let endMonth: Int
  
  public init(
    startYear: Int,
    startMonth: Int,
    endYear: Int,
    endMonth: Int
  ) {
    self.startYear = startYear
    self.startMonth = startMonth
    self.endYear = endYear
    self.endMonth = endMonth
  }
}

public struct MonthlyReport: Equatable {
  public let year: Int
  public let month: Int
  public let income: Int
  public let expense: Int
  public let netAmount: Int
  public let incomeShareOfPeriod: Double
  public let expenseShareOfPeriod: Double
  public let members: [MemberReport]
  public let categories: [CategoryReport]
  
  public init(
    year: Int,
    month: Int,
    income: Int,
    expense: Int,
    netAmount: Int,
    incomeShareOfPeriod: Double,
    expenseShareOfPeriod: Double,
    members: [MemberReport],
    categories: [CategoryReport]
  ) {
    self.year = year
    self.month = month
    self.income = income
    self.expense = expense
    self.netAmount = netAmount
    self.incomeShareOfPeriod = incomeShareOfPeriod
    self.expenseShareOfPeriod = expenseShareOfPeriod
    self.members = members
    self.categories = categories
  }
}

public struct MemberReport: Equatable {
  public let userId: Int
  public let nickname: String
  public let income: Int
  public let expense: Int
  public let incomeShare: Double
  public let expenseShare: Double
  
  public init(
    userId: Int,
    nickname: String,
    income: Int,
    expense: Int,
    incomeShare: Double,
    expenseShare: Double
  ) {
    self.userId = userId
    self.nickname = nickname
    self.income = income
    self.expense = expense
    self.incomeShare = incomeShare
    self.expenseShare = expenseShare
  }
}

public struct CategoryReport: Equatable {
  public let name: String
  public let income: Int
  public let expense: Int
  public let incomeShare: Double
  public let expenseShare: Double
  
  public init(
    name: String,
    income: Int,
    expense: Int,
    incomeShare: Double,
    expenseShare: Double
  ) {
    self.name = name
    self.income = income
    self.expense = expense
    self.incomeShare = incomeShare
    self.expenseShare = expenseShare
  }
}
