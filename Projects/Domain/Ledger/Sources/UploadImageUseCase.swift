import Foundation

import BaseDomain
import LedgerInterface

public struct UploadImageUseCase: UploadImageUseCaseInterface {
  private let ledgerRepo: LedgerRepositoryInterface
  
  public init(ledgerRepo: LedgerRepositoryInterface) {
    self.ledgerRepo = ledgerRepo
  }
  
  public func execute(imageData: Data) async throws -> ImageInfo {
    try await ledgerRepo.imageUpload(imageData)
  }
}
