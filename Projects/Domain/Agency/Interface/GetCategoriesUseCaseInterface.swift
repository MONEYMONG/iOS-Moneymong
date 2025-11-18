import Foundation

public protocol GetCategoriesUseCaseInterface {
  func execute(id: Int) async throws -> [String]
}
