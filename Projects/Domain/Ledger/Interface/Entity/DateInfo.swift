public struct DateInfo: Equatable {
  public let year: Int
  public let month: Int
  
  public init(year: Int, month: Int) {
    self.year = year
    self.month = month
  }
}

public struct DateRange: Equatable {
  public let start: DateInfo
  public let end: DateInfo
  
  public init(start: DateInfo, end: DateInfo) {
    self.start = start
    self.end = end
  }
  
  public init?(dic: [String : Int]) {
    guard let startYear = dic["startYear"],
          let startMonth = dic["startMonth"],
          let endYear = dic["endYear"],
          let endMonth = dic["endMonth"] else { return nil }
    self.start = DateInfo(year: startYear, month: startMonth)
    self.end = DateInfo(year: endYear, month: endMonth)
  }
  
  public var toDic: [String:Int] {
    return [
      "startYear" : start.year,
      "startMonth" : start.month,
      "endYear" : end.year,
      "endMonth" : end.month
    ]
  }
}
