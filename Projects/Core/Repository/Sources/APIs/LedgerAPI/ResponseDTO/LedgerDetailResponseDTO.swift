import Foundation

import BaseDomain
import MMNetworkInterface

struct LedgerDetailResponseDTO: Responsable {
  let id: Int
  let storeInfo: String
  let amount: Int
  let fundType: String
  let description: String
  let paymentDate: String
  let documentImageUrls: [DocumentImageURL]
  let authorName: String
  let category: String?
  
  struct DocumentImageURL: Decodable {
    let id: Int
    let documentImageUrl: String
  }
  
  var toEntity: LedgerDetail {
    .init(
      id: id,
      storeInfo: storeInfo,
      amount: amount,
      fundType: FundType(rawValue: fundType)!,
      description: description,
      paymentDate: paymentDate,
      documentImageUrls: documentImageUrls.map {
        LedgerDetail.ImageURL(id: $0.id, url: $0.documentImageUrl)
      },
      authorName: authorName,
      category: category
    )
  }
}

