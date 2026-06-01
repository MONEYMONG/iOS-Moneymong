import XCTest
@testable import Ledger
@testable import BaseDomainTesting


final class UploadDocumentUseCaseTests: XCTestCase {
  var sut: UploadDocumentUseCase!
  var mockRepo: MockLedgerRepository!
  
  override func setUpWithError() throws {
    mockRepo = MockLedgerRepository()
    sut = UploadDocumentUseCase(ledgerRepo: mockRepo)
  }
  
  override func tearDownWithError() throws {
    mockRepo = nil
    sut = nil
  }
  
  func test_execute_호출_시_에러가_발생하지_않는다면_Network_요청이_발생한다() async {
    // Arrange
    
    do {
      // Act
      try await sut.execute(ledgerID: 0, documentUrls: [])
      
      // Assert
      XCTAssertEqual(mockRepo.callCount.documentImagesUpload, 1)
    } catch {
      // Assert
      XCTFail()
    }
  }
}
