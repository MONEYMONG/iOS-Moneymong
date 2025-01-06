import Core
import UserInterface

public struct SearchUniversitiesUseCase: SearchUniversitiesUseCaseInterface {
  private let universityRepo: UniversityRepository
  
  public init(universityRepo: UniversityRepository) {
    self.universityRepo = universityRepo
  }
  
  public func execute(query: String) async throws -> [University] {
    try await universityRepo.universities(keyword: query)
  }
}
