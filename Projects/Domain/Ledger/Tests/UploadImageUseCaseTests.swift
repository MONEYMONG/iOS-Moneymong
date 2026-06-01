import XCTest
@testable import Ledger
@testable import BaseDomain
@testable import BaseDomainTesting

final class UploadImageUseCaseTests: XCTestCase {
  var sut: UploadImageUseCase!
  var mockRepo: MockLedgerRepository!
  
  override func setUpWithError() throws {
    mockRepo = MockLedgerRepository()
    sut = UploadImageUseCase(ledgerRepo: mockRepo)
  }
  
  override func tearDownWithError() throws {
    mockRepo = nil
    sut = nil
  }
  
  func test_execute_호출_시_에러가_발생하지_않는다면_ImageResponseDTO_Entity가_반환되어야_한다() async {
    // Arrange
    mockRepo.returnValue.imageUpload = ImageInfo(key: "key", url: "http")
    
    do {
      // Act
      let output = try await sut.execute(imageData: Data())
      
      // Assert
      XCTAssertEqual(mockRepo.callCount.imageUpload, 1)
      XCTAssertEqual(output, mockRepo.returnValue.imageUpload)
    } catch {
      // Assert
      XCTFail()
    }
  }
}
