import BaseFeature

public protocol JoinAgencyCoordinatorInterface: Coordinator {
  func start(agencyId: Int, agencyName: String, animated: Bool)
}
