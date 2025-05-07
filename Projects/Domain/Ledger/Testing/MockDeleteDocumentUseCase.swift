import Foundation

import LedgerInterface
import BaseDomain

public struct MockDeleteDocumentUseCase: DeleteDocumentUseCaseInterface {
  public init() {}
  
  public func execute(ledgerID: Int, documentID: Int) async throws { print(#file) }
}
