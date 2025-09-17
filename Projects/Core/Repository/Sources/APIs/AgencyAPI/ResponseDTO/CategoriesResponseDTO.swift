import Foundation

import MMNetworkInterface

struct CategoriesResponseDTO: Responsable {
  let agencyId: Int
  let categories: [String]
  
  var toEntity: [String] { categories }
}
