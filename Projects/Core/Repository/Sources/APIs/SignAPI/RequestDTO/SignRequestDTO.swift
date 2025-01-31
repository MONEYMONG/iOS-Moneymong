public struct SignRequestDTO: Encodable {
  let provider: String
  let accessToken: String
  let name: String?
  let code: String?
}
