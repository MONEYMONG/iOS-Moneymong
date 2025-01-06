import Foundation

// 소속의 초대코드를 재발급한다
public protocol ReissueCodeUseCaseInterface {
  func execute(id: Int) async throws -> String
}
