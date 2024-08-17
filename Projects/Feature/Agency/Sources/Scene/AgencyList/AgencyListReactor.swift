import ReactorKit

import Core

public final class AgencyListReactor: Reactor {
  
  public enum Action {
    case requestAgencyList
    case requestMyAgency
    case tap(Agency)
    case didPrefech(Int)
  }
  
  public enum Mutation {
    case agencyResponse(Result<[Agency], MoneyMongError>)
    case myAgencyResponse(Result<[Agency], MoneyMongError>)
    case setLoading(Bool)
    case setDestination(State.Destination)
    case setAlert(title: String, subTitle: String)
    case setPage(Int)
  }
  
  public struct State {
    var page: Int = 0
    @Pulse var myAgency: [Agency] = []
    @Pulse var items: [Agency] = []
    
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
  private let listLimit = 20
  
  init(agencyRepo: AgencyRepositoryInterface) {
    self.agencyRepo = agencyRepo
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .requestAgencyList:
      return .concat(
        .just(.setPage(0)),
        .just(.setLoading(true)),
        .task { try await agencyRepo.fetchList(page: currentState.page, size: listLimit) }
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
    case let .didPrefech(row):
      guard isPageable(row: row) else { return .empty() }
      return .concat([
        .just(.setLoading(true)),
        .just(.setPage(currentState.page + 1)),
        .task { try await agencyRepo.fetchList(page: currentState.page, size: listLimit) }
          .map { .agencyResponse(.success($0)) }
          .catch { return .just(.agencyResponse(.failure($0.toMMError))) },
        .just(.setLoading(false))
      ])
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case let .agencyResponse(.success(items)):
      if state.page == 0 {
        newState.items = []
      }
      newState.items += items
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
    case let .setPage(page):
      newState.page = page
    }
    
    return newState
  }
  
  private func isPageable(row: Int) -> Bool {
    let paginationRow: Int = Int(Double(currentState.page + 1) * Double(listLimit) * 0.8)
    return !currentState.isLoading &&
    paginationRow < row
  }
}
