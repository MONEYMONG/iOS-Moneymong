import Foundation

import BaseDomain

// 소속 목록을 검색한다
public protocol SearchAgencyUseCaseInterface {
  func execute(query: String) async throws -> [Agency]
}
