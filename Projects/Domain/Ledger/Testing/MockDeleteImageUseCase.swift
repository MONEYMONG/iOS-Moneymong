import LedgerInterface
import BaseDomain

public struct MockDeleteImageUseCase: DeleteImageUseCaseInterface {
  public init() {}
  
  public func execute(_ imageInfo: BaseDomain.ImageInfo) async throws { print(#filePath, #function) }
}
