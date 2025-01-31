import Foundation

/// 소속리스트 요청
struct AgencyListRequestDTO: Encodable {
  let page: Int
  let size: Int
  let sort: [String]?
}
