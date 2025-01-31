import XCTest
@testable import RepositoryTesting
@testable import Repository
@testable import User
@testable import UserInterface

final class UpdateSelectedAgencyUseCaseTests: XCTestCase {
  var sut: UpdateSelectedAgencyUseCase!
  var mockNetwork: MockNetworkManager!
  var mockLocalStorage: MockLocalStorage!
  override func setUpWithError() throws {
    mockNetwork = MockNetworkManager()
    mockLocalStorage = MockLocalStorage()
    let userRepo = UserRepository(networkManager: mockNetwork, localStorage: mockLocalStorage)
    sut = UpdateSelectedAgencyUseCase(userRepo: userRepo)
  }
  
  override func tearDownWithError() throws {
    mockNetwork = nil
    mockLocalStorage = nil
    sut = nil
  }
  
  func test_execute_호출_시_전달한_값이_LocalStorage에_저장되어야_한다() async {
    // Arrange
    let input = 0
    
    // Act
    sut.execute(id: input)
    // Assert
    XCTAssertEqual(mockLocalStorage.selectedAgency, input)
  }
}
