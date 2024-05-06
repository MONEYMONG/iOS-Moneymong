import Foundation

struct ImageResponseDTO: Responsable {
  let key: String
  let path: String
  
  var toEntity: ImageInfo {
    return ImageInfo(key: key, url: path)
  }
}
