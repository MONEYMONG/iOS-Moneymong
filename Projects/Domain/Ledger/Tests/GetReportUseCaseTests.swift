import XCTest
@testable import Ledger
@testable import BaseDomain
@testable import BaseDomainTesting

final class GetReportUseCaseTests: XCTestCase {
  var sut: GetReportUseCase!
  var mockRepo: MockLedgerRepository!
  
  override func setUpWithError() throws {
    mockRepo = MockLedgerRepository()
    sut = GetReportUseCase(ledgerRepo: mockRepo)
  }
  
  override func tearDownWithError() throws {
    mockRepo = nil
    sut = nil
  }
  
  func test_execute_현재월포함_최근3개월_리포트를_성공적으로_반환하고_레포지토리호출과_입력기간을_검증한다() async {
    // Arrange
    let expected = Report(
      agencyId: 0,
      agencyName: "test",
      period: .init(startYear: 0, startMonth: 0, endYear: 0, endMonth: 0),
      totalIncome: 0,
      totalExpense: 0,
      totalBalance: 0,
      monthly: []
    )
    mockRepo.returnValue.fetchReport = expected
    
    do {
      // Act
      let output = try await sut.excute(
        agencyID: 0,
        report: nil,
        currentDate: Calendar.current.date(from: DateComponents(year: 2026, month: 5))!,
      )
      
      // Assert
      XCTAssertEqual(output, expected)
      XCTAssertEqual(mockRepo.callCount.fetchReport, 1)
      XCTAssertEqual(mockRepo.inputValue.fetchReport!.from, Calendar.current.date(from: DateComponents(year: 2026, month: 3))!)
      XCTAssertEqual(mockRepo.inputValue.fetchReport!.to, Calendar.current.date(from: DateComponents(year: 2026, month: 5))!)
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  func test_execute_기존리포트에_월데이터를_추가해_총개수를_확장하고_레포지토리호출과_입력기간을_검증한다() async {
    // Arrange
    let current = Report(
      agencyId: 0,
      agencyName: "test",
      period: .init(startYear: 2026, startMonth: 3, endYear: 2026, endMonth: 5),
      totalIncome: 0,
      totalExpense: 0,
      totalBalance: 0,
      monthly: Array(
        repeating: .init(
          year: 0,
          month: 0,
          income: 0,
          expense: 0,
          netAmount: 0,
          incomeShareOfPeriod: 0,
          expenseShareOfPeriod: 0,
          members: [],
          categories: []
        ),
        count: 3
      )
    )
    let expected = Report(
      agencyId: 0,
      agencyName: "test",
      period: .init(startYear: 2025, startMonth: 12, endYear: 2026, endMonth: 2),
      totalIncome: 0,
      totalExpense: 0,
      totalBalance: 0,
      monthly: Array(
        repeating: .init(
          year: 0,
          month: 0,
          income: 0,
          expense: 0,
          netAmount: 0,
          incomeShareOfPeriod: 0,
          expenseShareOfPeriod: 0,
          members: [],
          categories: []
        ),
        count: 3
      )
    )
    mockRepo.returnValue.fetchReport = expected
    
    do {
      let output = try await sut.excute(
        agencyID: 0,
        report: current,
        currentDate: Calendar.current.date(from: DateComponents(year: 2026, month: 5))!
      )
      XCTAssertEqual(output.monthly.count, 6)
      XCTAssertEqual(output.period.startYear, 2025)
      XCTAssertEqual(output.period.startMonth, 12)
      XCTAssertEqual(output.period.endYear, 2026)
      XCTAssertEqual(output.period.endMonth, 5)
      XCTAssertEqual(mockRepo.callCount.fetchReport, 1)
      XCTAssertEqual(mockRepo.inputValue.fetchReport!.from, Calendar.current.date(from: DateComponents(year: 2025, month: 12))!)
      XCTAssertEqual(mockRepo.inputValue.fetchReport!.to, Calendar.current.date(from: DateComponents(year: 2026, month: 2))!)
    } catch {
      // Assert
      XCTFail("Unexpected error: \(error)")
    }
  }
}

