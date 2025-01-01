import XCTest
@testable import Ledger
@testable import Core
@testable import CoreTesting
@testable import LedgerInterface

final class GetLedgerDateRangeUseCaseTests: XCTestCase {
  var sut: GetLedgerDateRangeUseCase!
  var mockNetworkManager: MockNetworkManager!
  var mockLocalStorage: MockLocalStorage!
  
  override func setUpWithError() throws {
    mockLocalStorage = MockLocalStorage()
    mockNetworkManager = MockNetworkManager()
    let ledgerRepo = LedgerRepository(networkManager: mockNetworkManager, localStorage: mockLocalStorage)
    sut = GetLedgerDateRangeUseCase(ledgerRepo: ledgerRepo)
  }
  
  override func tearDownWithError() throws {
    mockLocalStorage = nil
    mockNetworkManager = nil
    sut = nil
  }
  
  func test_execute_호출_시_LocalStorage에_저장되어있는_값을_읽어온다() {
    // Arrange
    mockLocalStorage.ledgerDateRange = DateRange(
      start: DateInfo(year: 2024, month: 1),
      end: DateInfo(year: 2025, month: 1)
    ).toDic
    
    // Act
    let output = sut.excute()
    
    // Assert
    XCTAssertEqual(DateRange(dic: mockLocalStorage.ledgerDateRange!), output)
  }
}
