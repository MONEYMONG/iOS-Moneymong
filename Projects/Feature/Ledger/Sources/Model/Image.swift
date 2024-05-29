import Foundation

struct Image: Equatable {
  let id: UUID
  let data: Data
  
  enum Item: Equatable {
    case button
    case image(Image)
  }
}
