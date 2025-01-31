import Foundation

// 맴버의 역할을 변경한다
public protocol ChangeMemberRoleUseCaseInterface {
  func execute(id: Int, userId: Int, role: String) async throws
}
