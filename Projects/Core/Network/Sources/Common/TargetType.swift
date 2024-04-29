import Foundation

import Alamofire

public enum HTTPTask {
  case plain
  case requestJSONEncodable(Encodable)
  case upload(MultipartFormData)
}

public protocol TargetType: URLRequestConvertible {
  var baseURL: URL? { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var task: HTTPTask { get }
  var headers: [String: String]? { get }
}

extension TargetType {
  func asURLRequest() throws -> URLRequest {
    guard let encodedPath = path
      .addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    else {
      debugPrint("잘못된 URL")
      let urlError = AFError.createURLRequestFailed(error: URLError(.badURL))
      throw MoneyMongError.networkError(error: urlError)
    }

    guard let fullURL = baseURL?
      .appendingPathComponent(encodedPath)
      .absoluteString
      .removingPercentEncoding
    else {
      debugPrint("잘못된 URL")
      let urlError = AFError.createURLRequestFailed(error: URLError(.badURL))
      throw MoneyMongError.networkError(error: urlError)
    }

    var urlRequest = try URLRequest(url: fullURL, method: method)
    urlRequest.allHTTPHeaderFields = headers

    switch task {
    case .plain:
      break

    case let .requestJSONEncodable(params):
      urlRequest.httpBody = try! JSONEncoder().encode(params)

    case let .upload(multipartFormData):
      break
    }

    return urlRequest
  }
}
