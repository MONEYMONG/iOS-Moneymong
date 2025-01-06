import Foundation

// 새로운 소속을 생성한다
public protocol CreateAgencyUseCaseInterface {
  func execute(name: String, type: String) async throws -> Int
}
