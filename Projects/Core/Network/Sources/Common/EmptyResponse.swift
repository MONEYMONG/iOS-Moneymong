import Foundation

/// Response값이 없을때 사용
public struct EmptyResponse: Responsable {
  public var toEntity: EmptyResponse { .init() }
}
