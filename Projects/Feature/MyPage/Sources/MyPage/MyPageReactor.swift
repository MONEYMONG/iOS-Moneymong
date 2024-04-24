import UIKit

import DesignSystem
import NetworkService

import ReactorKit

public final class MyPageReactor: Reactor {
  
  public enum Action {
    case onappear
  }
  
  public enum Mutation {
    case setItem(UserInfo)
    case setLoading(Bool)
  }
  
  public struct State {
    @Pulse var isLoading = false
    @Pulse var item = [MyPageSectionItemModel.Model]()
    @Pulse var showToast = false
  }
  
  public let initialState: State = State()
  
  init(userRepo: UserRepositoryInterface = UserRepository()) {
    self.userRepo = userRepo
  }
  
  private let userRepo: UserRepositoryInterface
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .onappear:
      return Observable.concat([
        .just(.setLoading(false)),
        
        Single.create { observer in
          let task = Task {
            do {
              let result = try await self.userRepo.user()
              observer(.success(result))
            } catch {
              observer(.failure(error))
            }
          }
          
          return Disposables.create {
            task.cancel()
          }
        }
          .asObservable()
          .map { return .setItem($0)},
        
        .just(.setLoading(true)),
      ])
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case let .setItem(userInfo):
      newState.item = [
        .init(model: .account(userInfo), items: [.university(userInfo)]),
        .init(model: .setting("내 설정"), items: [
          .setting(.service),
          .setting(.privacy),
          .setting(.withdrawal),
          .setting(.logout),
          .setting(.versionInfo)
        ])
      ]
      
    case let .setLoading(value):
      newState.isLoading = value
    }
    
    
    return newState
  }
}
