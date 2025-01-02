import XCTest
@testable import Ledger
@testable import Core
@testable import CoreTesting
@testable import LedgerInterface

final class UploadImageUseCaseTests: XCTestCase {
  var sut: UploadImageUseCase!
  var mockNetworkManager: MockNetworkManager!
  var mockLocalStorage: MockLocalStorage!
  
  override func setUpWithError() throws {
    mockLocalStorage = MockLocalStorage()
    mockNetworkManager = MockNetworkManager()
    let ledgerRepo = LedgerRepository(networkManager: mockNetworkManager, localStorage: mockLocalStorage)
    sut = UploadImageUseCase(ledgerRepo: ledgerRepo)
  }
  
  override func tearDownWithError() throws {
    mockLocalStorage = nil
    mockNetworkManager = nil
    sut = nil
  }
  
  func test_execute_호출_시_에러가_발생하지_않는다면_ImageResponseDTO_Entity가_반환되어야_한다() async {
    // Arrange
    let dto = ImageResponseDTO(key: "", path: "")
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
