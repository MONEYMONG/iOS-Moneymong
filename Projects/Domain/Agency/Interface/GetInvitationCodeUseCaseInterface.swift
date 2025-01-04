import Foundation

// 소속의 초대코드를 가져온다
public protocol GetInvitationCodeUseCaseInterface {
  func execute(id: Int) async throws -> String
}
