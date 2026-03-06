import Foundation

struct CreateCategoryRequestDTO: Encodable {
  let agencyId: Int
  let name: String
}
