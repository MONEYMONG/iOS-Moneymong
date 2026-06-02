import Foundation

import LedgerInterface
import BaseDomain

public struct MockGetReportUseCase: GetReportUseCaseInterface {
  public init() {}
  
  public func execute(
    agencyID: Int,
    report: Report?,
    currentDate: Date,
    limit: Int
  ) async throws -> Report {
    // 1초 지연
    try await Task.sleep(nanoseconds: 1_000_000_000)
    return Report(
      agencyId: 0,
      agencyName: "Mock Agency",
      period: PeriodInfo(startYear: 2026, startMonth: 1, endYear: 2026, endMonth: 12),
      totalIncome: 1000,
      totalExpense: 500,
      totalBalance: 500,
      monthly: [
        MonthlyReport(
          year: 2026,
          month: 1,
          income: 1000,
          expense: 500,
          netAmount: 500,
          incomeShareOfPeriod: 1.0,
          expenseShareOfPeriod: 0.5,
          members: [
            MemberReport(
              userId: 1,
              nickname: "Dummy Member",
              income: 1000,
              expense: 500,
              incomeShare: 1.0,
              expenseShare: 0.5
            )
          ],
          categories: []
        ),
        MonthlyReport(
          year: 2026,
          month: 2,
          income: 1000,
          expense: 500,
          netAmount: 500,
          incomeShareOfPeriod: 1.0,
          expenseShareOfPeriod: 0.5,
          members: [],
          categories: []
        ),
        MonthlyReport(
          year: 2026,
          month: 3,
          income: 1000,
          expense: 500,
          netAmount: 500,
          incomeShareOfPeriod: 1.0,
          expenseShareOfPeriod: 0.5,
          members: [
            MemberReport(
              userId: 1,
              nickname: "Dummy Member",
              income: 1000,
              expense: 500,
              incomeShare: 1.0,
              expenseShare: 0.5
            )
          ],
          categories: Array(
            repeating: CategoryReport(
              name: "Dummy Category",
              income: 1000,
              expense: 500,
              incomeShare: 1.0,
              expenseShare: 0.5
            ),
            count: 5
          )
        )
      ]
    )
    
  }
}
