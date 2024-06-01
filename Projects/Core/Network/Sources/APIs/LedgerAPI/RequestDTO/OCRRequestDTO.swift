import Foundation

struct OCRRequestDTO: Encodable {
  let version: String = "V2"
  let requestId: String
  let timestamp: Int = 0
  let images: [ImageRequestDTO]
  
  struct ImageRequestDTO: Encodable {
    let format: String
    let name: String
  }
}


