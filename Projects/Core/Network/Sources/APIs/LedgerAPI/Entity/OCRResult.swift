import Foundation

public struct OCRResult {
  public let source: String
  public let amount: String
  public let date: [String]
  public let time: [String]
  
  public init(source: String, amount: String, date: [String], time: [String]) {
    self.source = source
    self.amount = amount
    self.date = date
    self.time = time
  }
}
