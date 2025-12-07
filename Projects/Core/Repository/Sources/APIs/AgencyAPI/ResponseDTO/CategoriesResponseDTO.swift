import Foundation

import BaseDomain
import MMNetworkInterface

struct CategoriesResponseDTO: Responsable {
  let agencyId: Int
  let categories: [CategoryResponseDTO]
  
  var toEntity: [MMCategory] { categories.map(\.toEntity) }
}
