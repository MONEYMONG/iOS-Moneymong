import Foundation

/// ErrorResponseModel
public struct ErrorResponse: Decodable {
  public let result: Bool?
  public let status: Int?
  public let code: String
  public let message: String?
  public let messages: [String]?
}
