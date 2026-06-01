import XCTest
@testable import Ledger
@testable import BaseDomain
@testable import BaseDomainTesting


final class UpdateLedgerUseCaseTests: XCTestCase {
  var sut: UpdateLedgerUseCase!
  var mockRepo: MockLedgerRepository!
  
  override func setUpWithError() throws {
    mockRepo = MockLedgerRepository()
    sut = UpdateLedgerUseCase(ledgerRepo: mockRepo)
  }
  
  override func tearDownWithError() throws {
    mockRepo = nil
    sut = nil
  }
  
  func test_execute_호출_시_에러가_발생하지_않는다면_LedgerDetail_Entity가_반환되어야_한다() async {
    // Arrange
    mockRepo.returnValue.update = LedgerDetail(
      id: 0,
      storeInfo: "",
      amount: 0,
      fundType: .expense,
      description: "",
      paymentDate: "",
      documentImageUrls: [],
      authorName: "",
      category: nil
    )
    
    do {
      // Act
      let detail = LedgerDetail(
        id: 0,
        storeInfo: "",
        amount: 0,
        fundType: .expense,
        description: "",
        paymentDate: "",
        documentImageUrls: [],
        authorName: "",
        category: nil
      )
      let output = try await sut.execute(request: detail)
      
      // Assert
      XCTAssertEqual(mockRepo.callCount.update, 1)
      XCTAssertEqual(output, mockRepo.returnValue.update)
    } catch {
      // Assert
      XCTFail()
    }
  }
}

