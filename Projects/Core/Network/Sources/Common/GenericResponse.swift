struct GenericResponse<T: Responsable> {
  let data: T
}

extension GenericResponse: Responsable {
  public var toEntity: T.Entity {
    return data.toEntity
  }
}

public protocol Responsable: Decodable {
  associatedtype Entity

  var toEntity: Entity { get }
}
