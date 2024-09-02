import UIKit

import Core

import ReactorKit

public final class MyPageReactor: Reactor {
  
  public enum Action {
    case onappear
    case logout
  }
  
  public enum Mutation {
    case setItem(UserInfo)
    case setLoading(Bool)
    case setError(MoneyMongError)
    case setDestination(State.Destination)
  }
  
  public struct State {
    @Pulse var isLoading = false
    @Pulse var item = [MyPageSectionItemModel.Model]()
    @Pulse var showToast = false
    @Pulse var error: MoneyMongError?
    @Pulse var destination: Destination?
    
    public enum Destination {
      case login
    }
  }
  
  public let initialState: State = State()
  
  init(userRepo: UserRepositoryInterface) {
    self.userRepo = userRepo
  }
  
  private let userRepo: UserRepositoryInterface
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .onappear:
      return .concat(
        .just(.setLoading(true)),
        
        .task { try await userRepo.user() }
        .map { .setItem($0) }
        .catch { return .just(.setError($0.toMMError))},
        
        .just(.setLoading(false))
      )
    case .logout:
      return .concat(
        .just(.setLoading(true)),
        
        .task { try await userRepo.logout() }
        .map { .setDestination(.login) }
        .catch { return .just(.setError($0.toMMError))},
        
        .just(.setLoading(false))
      )
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case let .setItem(userInfo):
      newState.item = [
        .init(model: .account(userInfo), items: [.university(userInfo)]),
        .init(model: .inquiry, items: [.kakaoInquiry]),
        .init(model: .setting("내 설정"), items: [
          .setting(.service),
          .setting(.privacy),
          .setting(.withdrawal),
          .setting(.logout),
          .setting(.versionInfo)
        ])
      ]
      
    case let .setError(error):
      newState.error = error
      
    case let .setLoading(value):
      newState.isLoading = value
      
    case let .setDestination(value):
      newState.destination = value
    }
    
    return newState
  }
}
