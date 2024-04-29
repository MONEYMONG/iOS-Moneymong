import Foundation

/// ErrorResponseModel
struct ErrorResponse: Decodable {
  let result: Bool
  let status: Int
  let code: String
  let message: String
}
