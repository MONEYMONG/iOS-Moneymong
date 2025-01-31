import XCTest
@testable import Ledger
@testable import Repository
@testable import RepositoryTesting
@testable import LedgerInterface

final class SaveLedgerDateRangeUseCaseTests: XCTestCase {
  var sut: SaveLedgerDateRangeUseCase!
  var mockNetworkManager: MockNetworkManager!
  var mockLocalStorage: MockLocalStorage!
  
  override func setUpWithError() throws {
    mockLocalStorage = MockLocalStorage()
    mockNetworkManager = MockNetworkManager()
    let ledgerRepo = LedgerRepository(networkManager: mockNetworkManager, localStorage: mockLocalStorage)
    sut = SaveLedgerDateRangeUseCase(ledgerRepo: ledgerRepo)
  }
  
  override func tearDownWithError() throws {
    mockLocalStorage = nil
    mockNetworkManager = nil
    sut = nil
  }
  
  func test_execute_호출_시_LocalStorage에_DateRange가_Dic형태로_저장되어야한다() {
    // Arrange
    let input = DateRange(
      start: DateInfo(year: 2024, month: 1),
      end: DateInfo(year: 2025, month: 1)
    )
    
    // Act
    sut.excute(dateRange: input)
    
    // Assert
    XCTAssertEqual(mockLocalStorage.ledgerDateRange, input.toDic)
  }
}
