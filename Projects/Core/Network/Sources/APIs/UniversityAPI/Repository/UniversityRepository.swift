import Foundation
import Alamofire

public protocol UniversityRepositoryInterface {
  func universities(keyword: String) async throws -> University
}

public final class UniversityRepository: UniversityRepositoryInterface {
  private let networkManager: NetworkManagerInterfacae

  public init(networkManager: NetworkManagerInterfacae = NetworkManager()) {
    self.networkManager = networkManager
  }

  public func universities(keyword: String) async throws -> University {
    let targetType = UniversityAPI.universities(keyword)
    let dto = try await networkManager.request(target: targetType, of: UniversityResponseDTO.self)
    return dto.toEntity
  }

  public func university(name: String, grade: Int) async throws -> Bool {
    let request = UniversityRequestDTO(universityName: name, grade: grade)
    let targetType = UniversityAPI.university(request)
    return try await networkManager.request(target: targetType, of: Bool.self)
  }
}

// 이거 없애야함
extension Bool: Responsable {
  public var toEntity: Bool {
    return false
  }
}
