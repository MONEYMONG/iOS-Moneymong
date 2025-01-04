import Foundation

// 맴버를 소속에서 쫒아낸다
protocol KickoutMemberUseCaseInterface {
  func execute(id: Int, userId: Int) async throws
}
