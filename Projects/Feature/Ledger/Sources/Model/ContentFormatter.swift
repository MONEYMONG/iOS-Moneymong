import Foundation

final class ContentFormatter {
  private lazy var numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
  }()
  
  func convertToAmount(with value: String) -> String? {
    guard let num = Int(value.filter { $0.isNumber }) else { return nil }
    return numberFormatter.string(from: NSNumber(value: num))
  }

  func convertToAmount(with value: Int) -> String? {
    return numberFormatter.string(from: NSNumber(value: value))
  }

  func convertToDate(with value: String, separator: Character = "/") -> String {
    var dateString = value
    if value.last == separator {
      dateString.removeLast()
      return dateString
    }

    var dateArray = Array(dateString)

    if dateArray.count == 5 {
      dateArray.insert(separator, at: 4)
    } else if dateArray.count == 8 {
      dateArray.insert(separator, at: 7)
    }

    return String(dateArray)
  }

  func convertToTime(with value: String) -> String {
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
  
  
  /**
   Convert Date to Time String
   -  2024-05-24 10:52:58 -> "10:52:58"
   */
  func convertToTime(date: Date) -> String {
    let components = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
    
    guard let hour = components.hour, let minute = components.minute, let second = components.second else {
      return ""
    }
    
    return String(format: "%02d:%02d:%02d", hour, minute, second)
  }
  
  /**
   Convert Date to Date String
   -  2024-05-24 10:52:58 -> "2024/05/24"
   */
  func convertToDate(date: Date) -> String {
    let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
    
    guard let year = components.year, let month = components.month, let day = components.day else {
      return ""
    }
    
    return String(format: "%d/%02d/%02d", year, month, day)
  }
  
  func mergeWithISO8601(date: String, time: String) -> String? {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "YYYY/MM/dd HH:mm:ss"
    inputFormatter.timeZone = TimeZone(abbreviation: "UTC")
    guard let date = inputFormatter.date(from: "\(date) \(time)") else { return nil }
    let outputFormatter = ISO8601DateFormatter()
    outputFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    outputFormatter.timeZone = TimeZone(abbreviation: "UTC")
    return outputFormatter.string(from: date)
  }
  
  func splitToDateTime(with dateString: String) -> (date: String, time: String) {
    let value = dateString.prefix(19).split(separator: "T")
    let date = String(value[0]).replacingOccurrences(of: "-", with: ".")
    let time = String(value[1])
    return (date, time)
  }
}
