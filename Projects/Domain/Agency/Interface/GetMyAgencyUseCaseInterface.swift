import Foundation

// 내 소속리스트를 가져온다
public protocol GetMyAgencyUseCaseInterface {
  func execute() async throws -> [Agency]
}
