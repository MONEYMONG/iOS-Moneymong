import Foundation

import BaseDomain

public protocol GetCategoriesUseCaseInterface {
  func execute(id: Int) async throws -> [MMCategory]
}
