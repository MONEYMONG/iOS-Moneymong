import Foundation

import BaseDomain

// 소속을 삭제한다
public protocol DeleteAgencyUseCaseInterface {
  func execute(id: Int?) async throws -> Agency?
}
