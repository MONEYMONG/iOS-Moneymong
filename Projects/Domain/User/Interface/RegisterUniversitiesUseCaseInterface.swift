public protocol RegisterUniversitiesUseCaseInterface {
  func execute(name: String?, grade: Int?) async throws
}
