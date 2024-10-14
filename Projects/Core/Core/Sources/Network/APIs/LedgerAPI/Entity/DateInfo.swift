public struct DateInfo {
  public let year: Int
  public let month: Int
  
  public init(year: Int, month: Int) {
    self.year = year
    self.month = month
  }
}

public struct DateRange {
  public let start: DateInfo
  public let end: DateInfo
  
  public init(start: DateInfo, end: DateInfo) {
    self.start = start
    self.end = end
  }
}
