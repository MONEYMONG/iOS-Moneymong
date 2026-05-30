import Foundation

struct ReportRequestDTO: Encodable {
  let startYear: Int
  let endYear: Int
  let startMonth: Int
  let endMonth: Int
  
  init(startYear: Int, endYear: Int, startMonth: Int, endMonth: Int) {
    self.startYear = startYear
    self.endYear = endYear
    self.startMonth = startMonth
    self.endMonth = endMonth
  }
}
