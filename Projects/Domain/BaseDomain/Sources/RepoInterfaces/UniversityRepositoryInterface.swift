public protocol UniversityRepositoryInterface {
  func university(name: String?, grade: Int?) async throws
  func universities(keyword: String) async throws -> [University]
}
