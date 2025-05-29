import Foundation

public struct CertificationResult: Equatable {
  public let certified: Bool
  public let agencyId: Int
  
  public init(certified: Bool, agencyId: Int) {
    self.certified = certified
    self.agencyId = agencyId
  }
}
