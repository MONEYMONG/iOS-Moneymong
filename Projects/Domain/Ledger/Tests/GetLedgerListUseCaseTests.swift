import XCTest
@testable import Ledger
@testable import Repository
@testable import RepositoryTesting
@testable import LedgerInterface

final class GetLedgerListUseCaseTests: XCTestCase {
  var sut: GetLedgerListUseCase!
  var mockNetworkManager: MockNetworkManager!
  var mockLocalStorage: MockLocalStorage!
  var mockWidgetRefreshController: MockWidgetRefreshController!
  
  override func setUpWithError() throws {
    mockLocalStorage = MockLocalStorage()
    mockNetworkManager = MockNetworkManager()
    mockWidgetRefreshController = MockWidgetRefreshController()
    let ledgerRepo = LedgerRepository(networkManager: mockNetworkManager, localStorage: mockLocalStorage)
    sut = GetLedgerListUseCase(ledgerRepo: ledgerRepo, widgetRefreshController: mockWidgetRefreshController)
  }
  
  override func tearDownWithError() throws {
    mockLocalStorage = nil
    mockNetworkManager = nil
    mockWidgetRefreshController = nil
    sut = nil
  }

  func test_execute_호출_시_에러가_발생하지_않는다면_네트워크_요청이_1회_발생하고_LedgerList_Entity가_반환되어야하며_LocalStorage에_요청_결과에_따른_LedgerInfo가_저장되고_Widget_Refresh가_1회_발생한다() async {
    // Arrange
    let dto = LedgerListResponseDTO(
      id: 0,
      ledgerDetailTotalCount: 0,
      totalBalance: 0,
      ledgerInfoViewDetails: [],
      agencyName: ""
    )
    mockNetworkManager.returnValue = dto
    
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
      XCTAssertEqual(mockNetworkManager.requestCallCount, 1)
      XCTAssertEqual(output, dto.toEntity)
      XCTAssertEqual(mockLocalStorage.currentLedgerInfo?["agencyName"] as? String, "")
      XCTAssertEqual(mockLocalStorage.currentLedgerInfo?["totalBalance"] as? Int, 0)
      XCTAssertEqual(mockWidgetRefreshController.refreshCallCount, 1)
    } catch {
      // Assert
      XCTFail()
    }
  }
}
