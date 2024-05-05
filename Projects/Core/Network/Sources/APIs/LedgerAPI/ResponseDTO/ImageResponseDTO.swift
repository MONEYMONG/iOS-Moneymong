import Foundation

struct ImageResponseDTO: Responsable {
  let key: String
  let path: String
  
  var toEntity: ImageURL {
    return ImageURL(key: key, url: path)
  }
}
