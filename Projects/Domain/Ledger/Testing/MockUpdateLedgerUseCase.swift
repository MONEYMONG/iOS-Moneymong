import Foundation

import LedgerInterface
import BaseDomain

public struct MockUpdateLedgerUseCase: UpdateLedgerUseCaseInterface {
  public init() {}
  
  public func execute(request: BaseDomain.LedgerDetail) async throws -> LedgerDetail {
    LedgerDetail(
      id: 0,
      storeInfo: "Test",
      amount: 1000,
      fundType: .expense,
      description: "test",
      paymentDate: "2023-11-16T15:36:11",
      documentImageUrls: [.init(id: 0, url: "https://picsum.photos/250/250")],
      authorName: "홍길동"
    )
  }
}
