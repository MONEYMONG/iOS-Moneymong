import Foundation

import BaseDomain

public protocol GetReportUseCaseInterface {
  func excute(agencyID: Int, report: Report?, currentDate: Date, limit: Int) async throws -> Report
}
