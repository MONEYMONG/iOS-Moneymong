import Foundation

public protocol DeleteCategoryUseCaseInterface {
  func execute(id: Int) async throws
}
