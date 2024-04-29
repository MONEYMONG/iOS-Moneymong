import Foundation

public protocol AgencyRepositoryInterface {

}

public final class AgencyRepository: AgencyRepositoryInterface {
  private let networkManager: NetworkManagerInterfacae

  public init(networkManager: NetworkManagerInterfacae = NetworkManager()) {
    self.networkManager = networkManager
  }
}
