import Foundation

import AgencyInterface
import BaseDomain
import Utility

public struct MockChangeMemberRoleUseCase: ChangeMemberRoleUseCaseInterface {
  public init() {}
  
  public func execute(id: Int, userId: Int, role: String) async throws {
    print("changed role: \(role)")
  }
}
