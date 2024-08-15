public protocol Responsable: Decodable {
  associatedtype Entity

  var toEntity: Entity { get }
  static var mock: Self? { get }
}

public extension Responsable {
  static var mock: Self? { return nil }
}
