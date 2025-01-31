import Foundation

import BaseDomain
import LedgerInterface

public struct DeleteImageUseCase: DeleteImageUseCaseInterface {
  private let ledgerRepo: LedgerRepositoryInterface
  
  public init(ledgerRepo: LedgerRepositoryInterface) {
    self.ledgerRepo = ledgerRepo
  }
  
  public func execute(_ imageInfo: ImageInfo) async throws {
    try await ledgerRepo.imageDelete(imageInfo)
  }
}
