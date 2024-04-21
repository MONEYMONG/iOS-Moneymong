import Moya

public extension MoyaProvider {
  func request(target: Target) async -> Result<Response, MoyaError> {
    await withCheckedContinuation { continuation in
      self.request(target) { result in
        continuation.resume(returning: result)
      }
    }
  }
}
