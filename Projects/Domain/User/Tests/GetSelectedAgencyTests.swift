import XCTest
@testable import CoreTesting
@testable import Core
@testable import User
@testable import UserInterface

final class GetSelectedAgencyUseCaseTests: XCTestCase {
  var sut: GetSelectedAgencyUseCase!
  var mockNetwork: MockNetworkManager!
  var mockLocalStorage: MockLocalStorage!
  override func setUpWithError() throws {
    mockNetwork = MockNetworkManager()
    mockLocalStorage = MockLocalStorage()
    let userRepo = UserRepository(networkManager: mockNetwork, localStorage: mockLocalStorage)
    sut = GetSelectedAgencyUseCase(userRepo: userRepo)
  }
  
  override func tearDownWithError() throws {
    mockNetwork = nil
    mockLocalStorage = nil
    sut = nil
  }
  
  func test_execute_호출_시_LocalStorage의_seletedAgency를_가져온다() async {
    // Arrange
    let input = 0
    mockLocalStorage.selectedAgency = input
    
    // Act
    let output = sut.execute()
    // Assert
    XCTAssertEqual(input, output)
  }
}
