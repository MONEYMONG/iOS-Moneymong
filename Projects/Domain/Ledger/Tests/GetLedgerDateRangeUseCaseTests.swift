import XCTest
@testable import Ledger
@testable import BaseDomainTesting
@testable import BaseDomain

final class GetLedgerDateRangeUseCaseTests: XCTestCase {
  var sut: GetLedgerDateRangeUseCase!
  var mockRepo: MockLedgerRepository!
  
  override func setUpWithError() throws {
    mockRepo = MockLedgerRepository()
    sut = GetLedgerDateRangeUseCase(ledgerRepo: mockRepo)
  }
  
  override func tearDownWithError() throws {
    mockRepo = nil
    sut = nil
  }

  
  func test_execute_호출_시_LocalStorage에_저장되어있는_값을_읽어온다() {
    // Arrange
    mockRepo.returnValue.fetchDateRange = DateRange(
      start: DateInfo(year: 2024, month: 1),
      end: DateInfo(year: 2025, month: 1)
    )
    
    // Act
    let output = sut.execute()
    
    // Assert
    XCTAssertEqual(mockRepo.returnValue.fetchDateRange, output)
  }
}
