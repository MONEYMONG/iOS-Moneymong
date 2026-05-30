import Foundation

import BaseDomain
import MMNetworkInterface

struct ReportResponseDTO: Responsable {
  let agencyId: Int
  let agencyName: String
  let period: PeriodInfoResponseDTO
  let totalIncome: Int
  let totalExpense: Int
  let totalBalance: Int
  let monthly: [MonthlyReportResponseDTO]

  var toEntity: Report {
    Report(
      agencyId: agencyId,
      agencyName: agencyName,
      period: period.toEntity,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      totalBalance: totalBalance,
      monthly: monthly.map { $0.toEntity }
    )
  }
}

struct PeriodInfoResponseDTO: Responsable {
  let startYear: Int
  let startMonth: Int
  let endYear: Int
  let endMonth: Int

  var toEntity: PeriodInfo {
    PeriodInfo(
      startYear: startYear,
      startMonth: startMonth,
      endYear: endYear,
      endMonth: endMonth
    )
  }
}

struct MonthlyReportResponseDTO: Responsable {
  let year: Int
  let month: Int
  let income: Int
  let expense: Int
  let netAmount: Int
  let incomeShareOfPeriod: Double
  let expenseShareOfPeriod: Double
  let members: [MemberReportResponseDTO]
  let categories: [CategoryReportResponseDTO]

  var toEntity: MonthlyReport {
    MonthlyReport(
      year: year,
      month: month,
      income: income,
      expense: expense,
      netAmount: netAmount,
      incomeShareOfPeriod: incomeShareOfPeriod,
      expenseShareOfPeriod: expenseShareOfPeriod,
      members: members.map { $0.toEntity },
      categories: categories.map { $0.toEntity }
    )
  }
}

struct MemberReportResponseDTO: Responsable {
  let userId: Int
  let nickname: String
  let income: Int
  let expense: Int
  let incomeShare: Double
  let expenseShare: Double

  var toEntity: MemberReport {
    MemberReport(
      userId: userId,
      nickname: nickname,
      income: income,
      expense: expense,
      incomeShare: incomeShare,
      expenseShare: expenseShare
    )
  }
}

struct CategoryReportResponseDTO: Responsable {
  let name: String
  let income: Int
  let expense: Int
  let incomeShare: Double
  let expenseShare: Double

  var toEntity: CategoryReport {
    CategoryReport(
      name: name,
      income: income,
      expense: expense,
      incomeShare: incomeShare,
      expenseShare: expenseShare
    )
  }
}
