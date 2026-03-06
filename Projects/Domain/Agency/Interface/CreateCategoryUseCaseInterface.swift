import Foundation

import BaseDomain

// 새로운 소속을 생성한다
public protocol CreateCategoryUseCaseInterface {
  func execute(agencyId: Int, name: String) async throws
}
