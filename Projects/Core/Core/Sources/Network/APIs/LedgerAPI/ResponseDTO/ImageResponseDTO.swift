import Foundation

import LedgerInterface

struct ImageResponseDTO: Responsable {
  let key: String
  let path: String
  
  var toEntity: ImageInfo {
    return ImageInfo(key: key, url: path)
  }
}
