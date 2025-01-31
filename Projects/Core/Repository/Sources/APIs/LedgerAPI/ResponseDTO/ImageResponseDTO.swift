import Foundation

import BaseDomain
import MMNetworkInterface

struct ImageResponseDTO: Responsable {
  let key: String
  let path: String
  
  var toEntity: ImageInfo {
    return ImageInfo(key: key, url: path)
  }
}
