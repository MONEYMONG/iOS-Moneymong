import XCTest
@testable import Ledger
@testable import BaseDomain
@testable import BaseDomainTesting


final class SaveLedgerDateRangeUseCaseTests: XCTestCase {
  var sut: SaveLedgerDateRangeUseCase!
  var mockRepo: MockLedgerRepository!
  
  override func setUpWithError() throws {
    mockRepo = MockLedgerRepository()
    sut = SaveLedgerDateRangeUseCase(ledgerRepo: mockRepo)
  }
  
  override func tearDownWithError() throws {
    mockRepo = nil
    sut = nil
  }
  
  func test_execute_호출_시_LocalStorage에_DateRange가_Dic형태로_저장되어야한다() {
    // Arrange
    let input = DateRange(
      start: DateInfo(year: 2024, month: 1),
      end: DateInfo(year: 2025, month: 1)
    )
    
    // Act
    sut.execute(dateRange: input)
    
    // Assert
    XCTAssertEqual(mockRepo.callCount.saveDateRange, 1)
  }
}
