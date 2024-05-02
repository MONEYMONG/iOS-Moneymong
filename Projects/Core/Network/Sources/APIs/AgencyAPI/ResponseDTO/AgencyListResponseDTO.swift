import Foundation

/// 소속리스트 조회
struct AgencyListResponseDTO: Responsable {
  let totalCount: Int
  let agencyList: [AgencyResponseDTO]
  
  var toEntity: [Agency] {
    agencyList.map(\.toEntity)
  }
}

/// 소속조회
struct AgencyResponseDTO: Responsable {
  let id: Int
  let name: String
  let headCount: Int
  let type: String
  
  var toEntity: Agency {
    .init(
      id: self.id,
      name: self.name,
      count: self.headCount,
      type: .init(rawValue: self.type) ?? .student
    )
  }
}

extension [AgencyResponseDTO]: Responsable {
  public var toEntity: [Agency] {
    self.map(\.toEntity)
  }
}
