import Core
import UserInterface

public struct RegisterUniversitiesUseCase: RegisterUniversitiesUseCaseInterface {
  private let universityRepo: UniversityRepository
  
  public init(universityRepo: UniversityRepository) {
    self.universityRepo = universityRepo
  }
  
  public func execute(name: String?, grade: Int?) async throws -> [University] {
    try await universityRepo.university(name: name, grade: grade)
  }
}
