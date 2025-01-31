public protocol Responsable: Decodable {
  associatedtype Entity

  var toEntity: Entity { get }
}
