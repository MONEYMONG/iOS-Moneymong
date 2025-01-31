import BaseDomain
import UserInterface

public struct RegisterUniversitiesUseCase: RegisterUniversitiesUseCaseInterface {
  private let universityRepo: UniversityRepositoryInterface
  
  public init(universityRepo: UniversityRepositoryInterface) {
    self.universityRepo = universityRepo
  }
  
  public func execute(name: String?, grade: Int?) async throws {
    try await universityRepo.university(name: name, grade: grade)
  }
}
