import XCTest
@testable import CoreTesting
@testable import Core
@testable import User
@testable import UserInterface

final class GetMyInfoUseCaseTests: XCTestCase {
  var sut: GetMyInfoUseCase!
  var mockNetwork: MockNetworkManager!
  var mockLocalStorage: MockLocalStorage!
  override func setUpWithError() throws {
    mockNetwork = MockNetworkManager()
    mockLocalStorage = MockLocalStorage()
    let userRepo = UserRepository(networkManager: mockNetwork, localStorage: mockLocalStorage)
    sut = GetMyInfoUseCase(userRepo: userRepo)
  }
  
  override func tearDownWithError() throws {
    mockNetwork = nil
    mockLocalStorage = nil
    sut = nil
  }
  
  func test_execute_호출_시_에러가_발생하지_않는다면_UserInfo_Entity가_반환되어야_한다() async {
    // Arrange
    mockNetwork.returnValue = UserResponseDTO(
      id: 0,
      userToken: nil,
      nickname: nil,
      email: nil,
      universityName: nil,
      grade: nil,
      provider: nil
    )
    
    // Act
    do {
      let output = try await sut.execute()
      // Assert
      XCTAssertEqual(mockNetwork.returnValue?.toEntity as! UserInfo, output)
      XCTAssertEqual(String(describing: mockNetwork.targetType!), String(describing: UserAPI.user))
      XCTAssertEqual(mockNetwork.requestCallCount, 1)
      XCTAssertEqual(mockLocalStorage.userID, 0)
    } catch {
      XCTFail()
    }
  }
}
