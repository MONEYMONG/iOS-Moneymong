import Foundation

struct LedgerListRequestDTO: Encodable {
  let startYear: Int
  let endYear: Int
  let startMonth: Int
  let endMonth: Int
  let page: Int
  let limit: Int
  let fundType: String?
  
  init(startYear: Int, endYear: Int, startMonth: Int, endMonth: Int, page: Int, limit: Int, fundType: String? = nil) {
    self.startYear = startYear
    self.endYear = endYear
    self.startMonth = startMonth
    self.endMonth = endMonth
    self.page = page
    self.limit = limit
    self.fundType = fundType
  }
}
