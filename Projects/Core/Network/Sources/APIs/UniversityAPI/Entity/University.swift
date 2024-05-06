public struct University {
  public var isSelected: Bool = false
  public let id: Int
  public let schoolName: String

  public init(id: Int, schoolName: String, isSelected: Bool = false) {
    self.id = id
    self.schoolName = schoolName
    self.isSelected = isSelected
  }
}
