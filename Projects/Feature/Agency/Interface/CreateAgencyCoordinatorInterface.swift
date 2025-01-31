import BaseFeature

public protocol CreateAgencyCoordinatorInterface: Coordinator {
  func start(universityType: UniversityType, animated: Bool)
}
