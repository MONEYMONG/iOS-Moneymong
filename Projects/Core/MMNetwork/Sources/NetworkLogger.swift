import Foundation
import OSLog

import Alamofire

final class NetworkLogger: EventMonitor {
  let queue = DispatchQueue(label: "NetworkLogger")
  
  private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "NetworkLogger")
  
  func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) where Value : Sendable {
    let statusCode = response.response?.statusCode ?? 0
    var log = (200..<300) ~= statusCode ? "OK" : "Fail"
    log.append("  ")
    
    log.append(request.description)
    log.append("\n\n")
    
    log.append("------------------- Request --------------------------\n\n")

    log.append("URL: \(request.request?.url?.absoluteString ?? "")\n")
    log.append("Method: \(request.request?.httpMethod ?? "")\n")
    log.append("Headers: \(request.request?.allHTTPHeaderFields ?? [:])\n")
    log.append("Authorization: \(request.request?.headers["Authorization"] ?? "None")\n")
    log.append("Body: \(request.request?.httpBody?.toPrettyPrintedString ?? "None")\n\n")
    
    log.append("------------------- Response --------------------------\n\n")
    
    log.append("\(response.data?.toPrettyPrintedString ?? "None")")
    
    logger.log("\(log)")
  }
}

private extension Data {
  var toPrettyPrintedString: String? {
    guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
          let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
          let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
    return prettyPrintedString as String
  }
}
