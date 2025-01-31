public protocol NetworkManagerInterfacae {
  @discardableResult
  func request<DTO: Responsable>(target: TargetType, of type: DTO.Type) async throws -> DTO
  func request<DTO: Responsable>(target: TargetType, of type: DTO.Type, cache: Cacheable?) async throws -> DTO
  func request(target: TargetType) async throws
}
