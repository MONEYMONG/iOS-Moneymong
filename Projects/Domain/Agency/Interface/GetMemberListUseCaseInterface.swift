import Foundation

// 소속에 속한 맴버리스트를 조회한다
public protocol GetMemberListUseCaseInterface {
  func execute(id: Int) async throws -> [Member]
}
