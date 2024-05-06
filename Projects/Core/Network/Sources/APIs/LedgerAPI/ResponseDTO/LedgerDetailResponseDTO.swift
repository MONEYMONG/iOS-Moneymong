import Foundation

struct LedgerDetailResponseDTO: Responsable {
  let id: Int
  let storeInfo: String
  let amount: Int
  let fundType: String
  let description: String
  let paymentDate: String
  let receiptImageUrls: [ReceiptImageURL]
  let documentImageUrls: [DocumentImageURL]
  let authorName: String
  
  struct DocumentImageURL: Decodable {
    let id: Int
    let documentImageUrl: String
  }

  struct ReceiptImageURL: Decodable {
    let id: Int
    let receiptImageUrl: String
  }
  
  var toEntity: LedgerDetail {
    .init(
      id: id,
      storeInfo: storeInfo,
      amount: amount,
      fundType: LedgerDetail.FundType(rawValue: fundType)!,
      description: description,
      paymentDate: paymentDate,
      receiptImageUrls: receiptImageUrls.map {
        LedgerDetail.ImageURL(id: $0.id, url: $0.receiptImageUrl)
      },
      documentImageUrls: documentImageUrls.map {
        LedgerDetail.ImageURL(id: $0.id, url: $0.documentImageUrl)
      },
      authorName: authorName
    )
  }
}

