import XCTest
@testable import Ledger
@testable import BaseDomain
@testable import BaseDomainTesting

final class GetLedgerDetailUseCaseTests: XCTestCase {
  var sut: GetLedgerDetailUseCase!
  var mockRepo: MockLedgerRepository!
  
  override func setUpWithError() throws {
    mockRepo = MockLedgerRepository()
    sut = GetLedgerDetailUseCase(ledgerRepo: mockRepo)
  }
  
  override func tearDownWithError() throws {
    mockRepo = nil
    sut = nil
  }
  
  func test_execute_호출_시_에러가_발생하지_않는다면_LedgerDetail_Entity가_반환되어야_한다() async {
    // Arrange
    mockRepo.returnValue.fetchLedgerDetail = LedgerDetail(
      id: 0,
      storeInfo: "",
      amount: 0,
      fundType: .income,
      description: "",
      paymentDate: "",
      documentImageUrls: [],
      authorName: "",
      category: nil
    )
    
    do {
      // Act
      let output = try await sut.execute(id: 0)
      
      // Assert
      XCTAssertEqual(output, mockRepo.returnValue.fetchLedgerDetail)
      XCTAssertEqual(mockRepo.callCount.fetchLedgerDetail, 1)
    } catch {
      // Assert
      XCTFail()
    }
  }
}
