import Foundation

import BaseDomain

struct ImageResponseDTO: Responsable {
  let key: String
  let path: String
  
  var toEntity: ImageInfo {
    return ImageInfo(key: key, url: path)
  }
}
