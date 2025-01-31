import XCTest
@testable import Ledger
@testable import Repository
@testable import RepositoryTesting
@testable import LedgerInterface

final class ReceiptOCRUseCaseTests: XCTestCase {
  var sut: ReceiptOCRUseCase!
  var mockNetworkManager: MockNetworkManager!
  var mockLocalStorage: MockLocalStorage!
  
  override func setUpWithError() throws {
    mockLocalStorage = MockLocalStorage()
    mockNetworkManager = MockNetworkManager()
    let ledgerRepo = LedgerRepository(networkManager: mockNetworkManager, localStorage: mockLocalStorage)
    sut = ReceiptOCRUseCase(ledgerRepo: ledgerRepo)
  }
  
  override func tearDownWithError() throws {
    mockLocalStorage = nil
    mockNetworkManager = nil
    sut = nil
  }
  
  func test_execute_호출_시_에러가_발생하지_않는다면_OCRResult_Entity가_반환되어야_한다() async {
    // Arrange
    let dto = OCRResponseDTO(
      version: "",
      requestId: "",
      timestamp: 0,
      images: []
    )
    mockNetworkManager.returnValue = dto
    
    do {
      // Act
      let output = try await sut.execute(imageData: Data())
      
      // Assert
      XCTAssertEqual(mockNetworkManager.requestCallCount, 1)
      XCTAssertEqual(output, dto.toEntity)
    } catch {
      // Assert
      XCTFail()
    }
  }
}
