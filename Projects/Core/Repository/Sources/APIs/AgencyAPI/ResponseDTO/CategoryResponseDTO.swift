import Foundation

import BaseDomain
import MMNetworkInterface

struct CategoryResponseDTO: Responsable {
  let id: Int
  let name: String
  
  var toEntity: MMCategory {
    return MMCategory(id: id, name: name)
  }
}
