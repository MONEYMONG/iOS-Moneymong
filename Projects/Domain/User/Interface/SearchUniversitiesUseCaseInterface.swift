public protocol SearchUniversitiesUseCaseInterface {
  func execute(query: String) async throws -> [University]
}
