import Foundation

final class ContentFormatter {
  private lazy var numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
  }()
  
  private lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY/MM"
    return formatter
  }()
  
  func amount(_ value: String) -> String? {
    guard let num = Int(value.filter { $0.isNumber }) else { return nil }
    return numberFormatter.string(from: NSNumber(value: num))
  }
  
  func date(_ value: String) -> String {
    var dateString = value
    if value.last == "/" {
      dateString.removeLast()
      return dateString
    }
    
    var dateArray = Array(dateString)
    
    if dateArray.count == 5 {
      dateArray.insert("/", at: 4)
    } else if dateArray.count == 8 {
      dateArray.insert("/", at: 7)
    }
    
    return String(dateArray)
  }
  
  func time(_ value: String) -> String {
    var timeString = value
    if value.last == ":" {
      timeString.removeLast()
      return timeString
    }
    
    var timeArray = Array(timeString)
    
    if timeArray.count == 3 {
      timeArray.insert(":", at: 2)
    } else if timeArray.count == 6 {
      timeArray.insert(":", at: 5)
    }
    
    return String(timeArray)
  }
  
  func dateBodyParameter(_ dateString: String) -> String? {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "YYYY/MM/dd HH:mm:ss"
    inputFormatter.timeZone = TimeZone(abbreviation: "UTC")
    guard let date = inputFormatter.date(from: dateString) else { return nil }
    let outputFormatter = ISO8601DateFormatter()
    outputFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    outputFormatter.timeZone = TimeZone(abbreviation: "UTC")
    return outputFormatter.string(from: date)
  }
  
  func getCurrentDate() -> [Int] {
    return dateFormatter.string(from: .now).split(separator: "/").map { Int($0)! }
  }
}
