import Foundation

import BaseDomain

// 소속 리스트를 가져온다
public protocol GetAgencyListUseCaseInterface {
  func execute(page: Int, size: Int) async throws -> [Agency]
}
