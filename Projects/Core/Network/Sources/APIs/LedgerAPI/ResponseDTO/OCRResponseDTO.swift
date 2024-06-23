import Foundation

struct OCRResponseDTO: Responsable {
  let version : String
  let requestId: String
  let timestamp: Int
  let images: [Image]
  
  struct Image: Decodable {
    let receipt: Receipt?
    let uid: String
    let name: String
    let inferResult: String
    let message: String
    let validationResult: ValidationResult
    
    struct Receipt: Decodable {
      let meta: Meta
      let result: Result
      
      struct Meta: Decodable {
        let estimatedLanguage: String
      }
      
      struct Result: Decodable {
        let storeInfo: StoreInfo?
        let paymentInfo: PaymentInfo?
        let subResults: [SubResult]?
        let totalPrice: TotalPrice?
        let subTotal: [SubTotal]?
        
        struct StoreInfo: Decodable {
          let name: Info?
          let subName: Info?
          let bizNum: Info?
          let addresses: [Info]?
          let tel: [Info]?
        }
        
        struct PaymentInfo: Decodable {
          let date: Info?
          let time: Info?
          let cardInfo: CardInfo?
          
          struct CardInfo: Decodable {
            let company: Info?
            let number: Info?
          }
        }
        
        struct SubResult: Decodable {
          let items: [Item]?
          
          struct Item: Decodable {
            let name: Info?
            let count: Info?
            let price: Price?
            
            struct Price: Decodable {
              let price: Info?
              let unitPrice: Info?
            }
          }
        }
        
        struct TotalPrice: Decodable {
          let price: Info?
        }
        
        struct SubTotal: Decodable {
          let taxPrice: [Info]?
        }
        
        struct Info: Decodable {
          let text: String?
          let formatted: BizNumFormatted?
          let keyText: String?
          
          struct BizNumFormatted: Decodable {
            let value: String?
            let year: String?
            let month: String?
            let day: String?
            let hour: String?
            let minute: String?
            let second: String?
          }
        }
      }
    }
    struct ValidationResult: Decodable {
      let result: String
    }
  }
  
  var toEntity: OCRResult {
    return OCRResult(
      inferResult: images.first?.inferResult ?? "ERROR",
      source: images.first?.receipt?.result.storeInfo?.name?.text ?? "",
      amount: images.first?.receipt?.result.totalPrice?.price?.text ?? "",
      date: [
        images.first?.receipt?.result.paymentInfo?.date?.formatted?.year ?? "",
        images.first?.receipt?.result.paymentInfo?.date?.formatted?.month ?? "",
        images.first?.receipt?.result.paymentInfo?.date?.formatted?.day ?? ""
      ],
      time: [
        images.first?.receipt?.result.paymentInfo?.time?.formatted?.hour ?? "",
        images.first?.receipt?.result.paymentInfo?.time?.formatted?.minute ?? "",
        images.first?.receipt?.result.paymentInfo?.time?.formatted?.second ?? ""
      ]
    )
  }
}
