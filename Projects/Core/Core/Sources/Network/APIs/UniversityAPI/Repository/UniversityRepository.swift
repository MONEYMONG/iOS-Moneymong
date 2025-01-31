import Foundation

import BaseDomain

public struct UniversityRepository: UniversityRepositoryInterface {
  private let networkManager: NetworkManagerInterfacae

  public init(networkManager: NetworkManagerInterfacae) {
    self.networkManager = networkManager
  }

  public func universities(keyword: String) async throws -> [University] {
    let targetType = UniversityAPI.universities(keyword)
    let dto = try await networkManager.request(target: targetType, of: UniversitiesResponseDTO.self)
    return dto.toEntity
  }

  public func university(name: String?, grade: Int?) async throws {
    let request = UniversityRequestDTO(universityName: name, grade: grade)
    let targetType = UniversityAPI.university(request)
    try await networkManager.request(target: targetType)
  }
}

