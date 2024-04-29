public struct UniversityResponseDTO: Responsable {
  public let id: Int?
  public let schoolName: String?

  public init(id: Int?, schoolName: String?) {
    self.id = id
    self.schoolName = schoolName
  }

  public var toEntity: University {
    .init(id: id ?? 0, schoolName: schoolName ?? "")
  }
}
