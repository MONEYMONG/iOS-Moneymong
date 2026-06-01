import Foundation

import BaseDomain
import LedgerInterface
import Utility

public struct GetReportUseCase: GetReportUseCaseInterface {
  private let ledgerRepo: LedgerRepositoryInterface
  
  public init(ledgerRepo: LedgerRepositoryInterface) {
    self.ledgerRepo = ledgerRepo
  }
  
  public func excute(agencyID: Int, report: Report?, currentDate: Date, limit: Int = 3) async throws -> Report {
    let calendar = Calendar.current

    if let report {
      guard let fromDate = calendar.date(byAdding: .month, value: report.monthly.count * -1 - (limit - 1), to: currentDate),
            let toDate = calendar.date(byAdding: .month, value: report.monthly.count * -1, to: currentDate) else {
        throw MoneyMongError.appError(.default, errorMessage: "잘못된 날짜가 입력되었습니다.\n날짜를 확인해 주세요.")
      }
      let newReport = try await ledgerRepo.fetchReport(agencyID: agencyID, from: fromDate, to: toDate)
      return newReport.copyWith(
        period: PeriodInfo(
          startYear:  newReport.period.startYear,
          startMonth: newReport.period.startMonth,
          endYear: report.period.endYear,
          endMonth: report.period.endMonth
        ),
        monthly: newReport.monthly + report.monthly
      )
    } else {
      guard let fromDate = calendar.date(byAdding: .month, value: -(limit - 1), to: currentDate) else {
        throw MoneyMongError.appError(.default, errorMessage: "잘못된 날짜가 입력되었습니다.\n날짜를 확인해 주세요.")
      }
      return try await ledgerRepo.fetchReport(agencyID: agencyID, from: fromDate, to: currentDate)
    }
  }
}
