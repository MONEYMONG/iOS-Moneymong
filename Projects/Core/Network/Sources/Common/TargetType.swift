import Foundation

import Alamofire

public enum HTTPTask {
  case plain
  case requestJSONEncodable(params: Encodable? = nil, query: Encodable? = nil)
  case upload(MultipartFormData)
}

public typealias HTTPMethod = Alamofire.HTTPMethod

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
      
    case let .requestJSONEncodable(params, query):
      if let params {
        urlRequest.httpBody = try! JSONEncoder().encode(params)

      }
      
      if let query {
        var urlComponents = URLComponents(string: fullURL)!
        urlComponents.queryItems = []
        
        guard let object = try? JSONEncoder().encode(query) else { break }
        guard let dictionary = try? JSONSerialization.jsonObject(with: object)
                as? [String: Any] else {
          break
        }
        
        dictionary
          .forEach({ key, value in
            let item = URLQueryItem(name: key, value: "\(value)")
            urlComponents.queryItems?.append(item)
          })
        urlRequest.url = urlComponents.url
      }
    case .upload:
      break
    }
    return urlRequest
  }
}
