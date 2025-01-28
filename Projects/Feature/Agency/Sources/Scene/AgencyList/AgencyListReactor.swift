import ReactorKit

import Core

public final class AgencyListReactor: Reactor {
  private enum Const {
    static let feedbackUrl = "https://asked.kr/moneymong"
  }
  
  enum Item: Equatable {
    case feedback
    case agency(Agency)
  }
  
  public enum Action {
    case requestAgencyList
    case requestMyAgency
    case tap(Agency)
    case didPrefech(Int)
    case feedBack
    case tapSearchBar // 네비게이션의 search 아이콘을 눌렀을때
    case tapSearchButton // 키보드의 검색 버튼을 눌렀을떄
    case tapCancelButton
    case searchTextChanged(String?)
    case viewDidLoad
  }
  
  public enum Mutation {
    case agencyResponse(Result<[Agency], MoneyMongError>)
    case myAgencyResponse(Result<[Agency], MoneyMongError>)
    case setLoading(Bool)
    case setDestination(State.Destination)
    case setAlert(title: String, subTitle: String)
    case setPage(Int)
    case setQuery(String?)
    case setUserInfo(Result<UserInfo, MoneyMongError>)
  }
  
  public struct State {
    @Pulse var query: String?
    
    var page: Int = 0
    @Pulse var myAgency: [Agency] = []
    @Pulse var items: [Item] = [.feedback]
    @Pulse var userInfo: UserInfo?
    
    @Pulse var error: MoneyMongError?
    @Pulse var isLoading = false
    @Pulse var alert: (title: String, subTitle: String)?
    @Pulse var destination: Destination?
    
    public enum Destination {
      case joinAgency(Agency)
      case web(String)
    }
  }
  
  public let initialState: State = State()
  
  private let agencyRepo: AgencyRepositoryInterface
  private let userRepo: UserRepositoryInterface
  
  private let listLimit = 20
  
  init(
    agencyRepo: AgencyRepositoryInterface,
    userRepo: UserRepositoryInterface
  ) {
    self.agencyRepo = agencyRepo
    self.userRepo = userRepo
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
      return .task { try await agencyRepo.fetchMyAgency() }
        .map { .myAgencyResponse(.success($0))}
        .catchAndReturn(.myAgencyResponse(.success([])))
      
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
      
    case .feedBack:
      return .just(.setDestination(.web(Const.feedbackUrl)))
    
    case .tapSearchBar:
      return .just(.setQuery(""))
      
    case .tapSearchButton:
      guard let query = currentState.query else { return .empty() }
      
      return .concat([
        .just(.setLoading(true)),
        .task { try await agencyRepo.search(query: query) }
          .map { .agencyResponse(.success($0)) }
          .catch { return .just(.agencyResponse(.failure($0.toMMError))) },
        .just(.setLoading(false))
      ])
      
    case .tapCancelButton:
      return .concat([
        .just(.setQuery(nil)),
        .just(.setPage(0)),
        .task { try await agencyRepo.fetchList(page: currentState.page, size: listLimit) }
          .map { .agencyResponse(.success($0)) }
          .catch { return .just(.agencyResponse(.failure($0.toMMError))) },
      ])
      
    case let .searchTextChanged(query):
      return .just(.setQuery(query))
    case .viewDidLoad:
      return .task {
        try await userRepo.user()
      }
      .map { .setUserInfo(.success($0)) }
      .catch { return .just(.setUserInfo(.failure($0.toMMError))) }
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case let .agencyResponse(.success(items)):
      if state.page == 0 {
        newState.items = initialState.items
      }
      newState.items += items.map { .agency($0) }
      
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
      
    case let .setQuery(query):
      newState.query = query
      
    case let .setUserInfo(.success(userInfo)):
      newState.userInfo = userInfo
      
    case let .setUserInfo(.failure(error)):
      newState.error = error
    }
    
    return newState
  }
  
  private func isPageable(row: Int) -> Bool {
    let paginationRow: Int = Int(Double(currentState.page + 1) * Double(listLimit) * 0.8)
    return !currentState.isLoading &&
    paginationRow < row
  }
}
