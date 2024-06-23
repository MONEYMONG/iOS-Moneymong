import Foundation

public struct OCRResult {
  public let inferResult: String
  public let source: String
  public let amount: String
  public let date: [String]
  public let time: [String]
  
  public init(inferResult: String, source: String, amount: String, date: [String], time: [String]) {
    self.inferResult = inferResult
    self.source = source
    self.amount = amount
    self.date = date
    self.time = time
  }
}
