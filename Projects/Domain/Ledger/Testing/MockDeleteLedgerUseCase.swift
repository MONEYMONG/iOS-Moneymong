import Foundation

import LedgerInterface
import BaseDomain

public struct MockDeleteLedgerUseCase: DeleteLedgerUseCaseInterface {
  public init() {}
  
  public func execute(id: Int) async throws { print(#file) }
}
