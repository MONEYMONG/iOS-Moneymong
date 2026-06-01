import XCTest
@testable import Ledger
@testable import BaseDomainTesting

final class CreateLedgerUseCaseTests: XCTestCase {
  var sut: CreateLedgerUseCase!
  var mockRepo: MockLedgerRepository!
  
  override func setUpWithError() throws {
    mockRepo = MockLedgerRepository()
    sut = CreateLedgerUseCase(ledgerRepo: mockRepo)
  }
  
  override func tearDownWithError() throws {
    mockRepo = nil
    sut = nil
  }
  
  func test_execute_호출_시_에러가_발생하지_않는다면_Network_요청이_발생한다() async {
    do {
      // Act
      try await sut.execute(
        id: 0,
        storeInfo: "",
        fundType: .expense,
        amount: 0,
        description: "",
        paymentDate: "",
        documentImageUrls: [],
        category: nil
      )
      
      // Assert
      XCTAssertEqual(mockRepo.callCount.create, 1)
    } catch {
      // Assert
      XCTFail()
    }
  }
}
