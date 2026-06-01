import XCTest
@testable import Ledger
@testable import BaseDomain
@testable import BaseDomainTesting
@testable import RepositoryTesting

final class GetLedgerListUseCaseTests: XCTestCase {
  var sut: GetLedgerListUseCase!
  var mockRepo: MockLedgerRepository!
  var mockWidgetRefreshController: MockWidgetRefreshController!
  
  override func setUpWithError() throws {
    mockWidgetRefreshController = MockWidgetRefreshController()
    mockRepo = MockLedgerRepository()
    sut = GetLedgerListUseCase(ledgerRepo: mockRepo, widgetRefreshController: mockWidgetRefreshController)
  }
  
  override func tearDownWithError() throws {
    mockRepo = nil
    mockWidgetRefreshController = nil
    sut = nil
  }

  func test_execute_호출_시_에러가_발생하지_않는다면_네트워크_요청이_1회_발생하고_LedgerList_Entity가_반환되어야하며_LocalStorage에_요청_결과에_따른_LedgerInfo가_저장되고_Widget_Refresh가_1회_발생한다() async {
    // Arrange
    mockRepo.returnValue.fetchLedgerList = LedgerList(
      totalBalance: 0,
      totalCount: 1,
      ledgers: [
        Ledger(id: 0, storeInfo: "", fundType: .expense, amount: 0, balance: 0, order: 0, paymentDate: "")
      ]
    )
    
    do {
      // Act
      let output = try await sut.excute(
        id: 0,
        start: .init(year: 2024, month: 1),
        end: .init(year: 2025, month: 1),
        page: 0,
        limit: 0,
        fundType: nil
      )
      
      // Assert
      XCTAssertEqual(output, mockRepo.returnValue.fetchLedgerList)
      XCTAssertEqual(mockRepo.callCount.fetchLedgerList, 1)
      XCTAssertEqual(mockWidgetRefreshController.refreshCallCount, 1)
    } catch {
      // Assert
      XCTFail()
    }
  }
}

