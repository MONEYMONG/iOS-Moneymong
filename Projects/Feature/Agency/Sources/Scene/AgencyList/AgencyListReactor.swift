import ReactorKit

import NetworkService

public final class AgencyListReactor: Reactor {
  
  public enum Action {
    case requestAgencyList
    case requestMyAgency
    case tap(Agency)
  }
  
  public enum Mutation {
    case agencyResponse(Result<[Agency], MoneyMongError>)
    case myAgencyResponse(Result<[Agency], MoneyMongError>)
    case setLoading(Bool)
    case setDestination(State.Destination)
    case setAlert(title: String, subTitle: String)
  }
  
  public struct State {
    @Pulse var myAgency: [Agency] = []
    @Pulse var items: [AgencySectionModel] = []
    
    @Pulse var error: MoneyMongError?
    @Pulse var isLoading = false
    @Pulse var alert: (title: String, subTitle: String)?
    @Pulse var destination: Destination?
    
    public enum Destination {
      case joinAgency(Agency)
    }
  }
  
  public let initialState: State = State()
  private let agencyRepo: AgencyRepositoryInterface
  
  init(agencyRepo: AgencyRepositoryInterface) {
    self.agencyRepo = agencyRepo
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .requestAgencyList:
      return .concat(
        .just(.setLoading(true)),
        
        .task { try await agencyRepo.fetchList() }
        .map { .agencyResponse(.success($0)) }
        .catch { return .just(.agencyResponse(.failure($0.toMMError))) },
        
        .just(.setLoading(false))
      )
      
    case .requestMyAgency:
      return .concat(
        .just(.setLoading(true)),
        
        .task { try await agencyRepo.fetchMyAgency() }
        .map { .myAgencyResponse(.success($0))}
        .catchAndReturn(.myAgencyResponse(.success([]))),
        
        .just(.setLoading(false))
      )
      
    case let .tap(agency):
      if currentState.myAgency.contains(agency) {
        return .just(.setAlert(
          title: "이미 가입한 소속입니다.",
          subTitle: "장부 페이지에서 가입한 소속을 확인해보세요"
        ))
      } else {
        return .just(.setDestination(.joinAgency(agency)))
      }
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case let .agencyResponse(.success(items)):
      if items.isEmpty == false {
        newState.items = [.init(items: items)]
      }
    case let .agencyResponse(.failure(error)):
      newState.error = error
      
    case let .myAgencyResponse(.success(items)):
      newState.myAgency = items
      
    case let .myAgencyResponse(.failure(error)):
      newState.error = error
      
    case let .setLoading(value):
      newState.isLoading = value
      
    case let .setDestination(destination):
      newState.destination = destination
      
    case let .setAlert(title, subTitle):
      newState.alert = (title, subTitle)
    }
    
    return newState
  }
}
