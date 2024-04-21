public struct GenericResponse<T: Decodable>: Decodable {
  let data: T?
}
