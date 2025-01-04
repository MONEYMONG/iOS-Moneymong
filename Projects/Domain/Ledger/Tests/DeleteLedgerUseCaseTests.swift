import XCTest
@testable import Ledger
@testable import Core
@testable import CoreTesting
@testable import LedgerInterface

final class DeleteLedgerUseCaseTests: XCTestCase {
  var sut: DeleteLedgerUseCase!
  var mockNetworkManager: MockNetworkManager!
  var mockLocalStorage: MockLocalStorage!
  
  override func setUpWithError() throws {
    mockLocalStorage = MockLocalStorage()
    mockNetworkManager = MockNetworkManager()
    let ledgerRepo = LedgerRepository(networkManager: mockNetworkManager, localStorage: mockLocalStorage)
    sut = DeleteLedgerUseCase(ledgerRepo: ledgerRepo)
  }
  
  override func tearDownWithError() throws {
    mockLocalStorage = nil
    mockNetworkManager = nil
    sut = nil
  }
  
  func test_execute_호출_시_에러가_발생하지_않는다면_Network_요청이_발생한다() async {
    // Arrange
    
    do {
      // Act
      try await sut.execute(id: 0)
      
      // Assert
      XCTAssertEqual(mockNetworkManager.requestCallCount, 1)
    } catch {
      // Assert
      XCTFail()
    }
  }
}
