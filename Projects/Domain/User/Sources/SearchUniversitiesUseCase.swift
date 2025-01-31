import BaseDomain
import UserInterface

public struct SearchUniversitiesUseCase: SearchUniversitiesUseCaseInterface {
  private let universityRepo: UniversityRepositoryInterface
  
  public init(universityRepo: UniversityRepositoryInterface) {
    self.universityRepo = universityRepo
  }
  
  public func execute(query: String) async throws -> [University] {
    try await universityRepo.universities(keyword: query)
  }
}
