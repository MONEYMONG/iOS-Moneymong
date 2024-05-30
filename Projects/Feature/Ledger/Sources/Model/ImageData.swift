import Foundation

struct ImageData: Equatable {
  let id: UUID
  let data: Data
  
  enum Item: Equatable {
    case button
    case image(ImageData)
  }
}
