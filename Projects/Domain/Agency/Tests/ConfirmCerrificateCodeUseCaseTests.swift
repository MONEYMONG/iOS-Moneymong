import XCTest
@testable import Agency
@testable import BaseDomain
@testable import BaseDomainTesting

final class ConfirmCerrificateCodeUseCaseTests: XCTestCase {
  var sut: ConfirmCertificateCodeUseCase!
  var mockAgencyRepo: MockAgencyRepository!
  var mockUserRepo: MockUserRepository!

  override func setUpWithError() throws {
    mockAgencyRepo = MockAgencyRepository()
    mockUserRepo = MockUserRepository()
    sut = ConfirmCertificateCodeUseCase(agencyRepo: mockAgencyRepo, userRepo: mockUserRepo)
  }

  override func tearDownWithError() throws {
    mockAgencyRepo = nil
    mockUserRepo = nil
    sut = nil
  }

  func test_execute_코드배열로_호출_시_인증에_성공하면_소속을_저장하고_해당_Agency를_반환한다() async {
    // Arrange
    let agency = Agency(id: 1, name: "몽테스트", count: 1)
    mockAgencyRepo.returnValue.certificateCode = CertificationResult(certified: true, agencyId: agency.id)
    mockAgencyRepo.returnValue.fetchMyAgency = [agency]

    do {
      // Act
      let output = try await sut.execute(code: ["1", "2", "3", "4"])

      // Assert
      XCTAssertEqual(output, agency)
      XCTAssertEqual(mockAgencyRepo.inputValue.certificateCode, "1234")
      XCTAssertEqual(mockUserRepo.inputValue.updateSelectedAgency, agency.id)
      XCTAssertEqual(mockUserRepo.callCount.updateSelectedAgency, 1)
    } catch {
      // Assert
      XCTFail()
    }
  }

  func test_execute_코드배열로_호출_시_인증에_실패하면_nil을_반환한다() async {
    // Arrange
    mockAgencyRepo.returnValue.certificateCode = CertificationResult(certified: false, agencyId: 0)

    do {
      // Act
      let output = try await sut.execute(code: ["1", "2", "3", "4"])

      // Assert
      XCTAssertNil(output)
      XCTAssertEqual(mockUserRepo.callCount.updateSelectedAgency, 0)
    } catch {
      // Assert
      XCTFail()
    }
  }

  func test_execute_코드와_소속ID로_호출_시_이미_가입된_소속이면_인증코드_확인없이_소속을_저장하고_해당_Agency를_반환한다() async {
    // Arrange
    let agency = Agency(id: 1, name: "몽테스트", count: 1)
    mockAgencyRepo.returnValue.fetchMyAgency = [agency]

    do {
      // Act
      let output = try await sut.execute(code: "1234", agencyID: agency.id)

      // Assert
      XCTAssertEqual(output, agency)
      XCTAssertEqual(mockAgencyRepo.callCount.certificateCode, 0)
      XCTAssertEqual(mockUserRepo.inputValue.updateSelectedAgency, agency.id)
    } catch {
      // Assert
      XCTFail()
    }
  }

  func test_execute_코드와_소속ID로_호출_시_가입되지_않은_소속이고_인증에_성공하면_해당_Agency를_반환한다() async {
    // Arrange
    let agency = Agency(id: 2, name: "몽테스트", count: 1)
    mockAgencyRepo.returnValue.fetchMyAgency = [agency]
    mockAgencyRepo.returnValue.certificateCode = CertificationResult(certified: true, agencyId: agency.id)

    do {
      // Act
      let output = try await sut.execute(code: "1234", agencyID: 999)

      // Assert
      XCTAssertEqual(output, agency)
      XCTAssertEqual(mockAgencyRepo.callCount.certificateCode, 1)
      XCTAssertEqual(mockUserRepo.inputValue.updateSelectedAgency, agency.id)
    } catch {
      // Assert
      XCTFail()
    }
  }

  func test_execute_코드와_소속ID로_호출_시_가입되지_않은_소속이고_인증에_실패하면_nil을_반환한다() async {
    // Arrange
    mockAgencyRepo.returnValue.fetchMyAgency = []
    mockAgencyRepo.returnValue.certificateCode = CertificationResult(certified: false, agencyId: 0)

    do {
      // Act
      let output = try await sut.execute(code: "1234", agencyID: 999)

      // Assert
      XCTAssertNil(output)
      XCTAssertEqual(mockUserRepo.callCount.updateSelectedAgency, 0)
    } catch {
      // Assert
      XCTFail()
    }
  }
}
