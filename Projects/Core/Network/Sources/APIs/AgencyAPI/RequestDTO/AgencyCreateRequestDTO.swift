import Foundation

/// 소속생성요청에 사용
struct AgencyCreateRequestDTO: Encodable {
  let name: String
  let description: String
  let agencyType: String
}
