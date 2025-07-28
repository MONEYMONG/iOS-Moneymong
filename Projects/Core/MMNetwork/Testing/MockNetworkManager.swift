import Repository
import MMNetworkInterface
import Utility

public final class MockNetworkManager: NetworkManagerInterfacae {
  public var returnValue: (any Responsable)?
  public var targetType: (any TargetType)?
  public var isError: Bool = false
  
  public var requestCallCount: Int = 0
  
  public func request<DTO>(target: any TargetType, of type: DTO.Type) async throws -> DTO where DTO : Responsable {
    requestCallCount += 1
    targetType = target
    if isError { throw MoneyMongError.appError(.default) }
    return returnValue as! DTO
  }
  
  public func request(target: any TargetType) async throws {
    requestCallCount += 1
    targetType = target
    if isError { throw MoneyMongError.appError(.default) }
  }
}
