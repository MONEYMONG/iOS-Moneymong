import Foundation

/// 소속 ID
struct AgencyIDResponseDTO: Responsable {
  let id: Int
  
  var toEntity: Int { return self.id }
}
