import XCTest
@testable import Ledger
@testable import BaseDomainTesting

final class DeleteDocumentUseCaseTests: XCTestCase {
  var sut: DeleteDocumentUseCase!
  var mockRepo: MockLedgerRepository!
  
  override func setUpWithError() throws {
    mockRepo = MockLedgerRepository()
    sut = DeleteDocumentUseCase(ledgerRepo: mockRepo)
  }
  
  override func tearDownWithError() throws {
    mockRepo = nil
    sut = nil
  }
  
  func test_execute_호출_시_에러가_발생하지_않는다면_Network_요청이_발생한다() async {
    // Arrange
    
    do {
      // Act
      try await sut.execute(ledgerID: 0, documentID: 0)
      
      // Assert
      XCTAssertEqual(mockRepo.callCount.documentImageDelete, 1)
    } catch {
      // Assert
      XCTFail()
    }
  }
}
