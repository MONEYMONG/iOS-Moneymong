import XCTest
@testable import Ledger
@testable import Core
@testable import CoreTesting

final class CreateLedgerUseCaseTests: XCTestCase {
  var sut: CreateLedgerUseCase!
  var mockNetworkManager: MockNetworkManager!
  var mockLocalStorage: MockLocalStorage!
  
  override func setUpWithError() throws {
    mockLocalStorage = MockLocalStorage()
    mockNetworkManager = MockNetworkManager()
    let ledgerRepo = LedgerRepository(networkManager: mockNetworkManager, localStorage: mockLocalStorage)
    sut = CreateLedgerUseCase(ledgerRepo: ledgerRepo)
  }
  
  override func tearDownWithError() throws {
    mockLocalStorage = nil
    mockNetworkManager = nil
    sut = nil
  }
  
  func test_execute_호출_시_에러가_발생하지_않는다면_Network_요청이_발생한다() async {
    // Arrange
   let dto = LedgerDetailResponseDTO(
      id: 0,
      storeInfo: "",
      amount: 0,
      fundType: FundType.expense.rawValue,
      description: "",
      paymentDate: "",
      receiptImageUrls: [],
      documentImageUrls: [],
      authorName: ""
    )
    mockNetworkManager.returnValue = dto
    
    do {
      // Act
      try await sut.execute(
        id: 0,
        storeInfo: "",
        fundType: .expense,
        amount: 0,
        description: "",
        paymentDate: "",
        receiptImageUrls: [],
        documentImageUrls: []
      )
      
      // Assert
      XCTAssertEqual(mockNetworkManager.requestCallCount, 1)
    } catch {
      // Assert
      XCTFail()
    }
  }
}
