import Foundation

import LedgerInterface
import BaseDomain

public struct MockUploadDocumentUseCase: UploadDocumentUseCaseInterface {
  public init() {}
  
  public func execute(ledgerID: Int, documentUrls: [String]) async throws { print(#file) }
}
