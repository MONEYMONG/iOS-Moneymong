import UIKit

import NetworkService

import ReactorKit

public final class MyPageReactor: Reactor {
  
  public enum Action {
    case onappear
    case logout
  }
  
  public enum Mutation {
    case setItem(UserInfo)
    case setLoading(Bool)
    case setDestination(State.Destination)
  }
  
  public struct State {
    @Pulse var isLoading = false
    @Pulse var item = [MyPageSectionItemModel.Model]()
    @Pulse var showToast = false
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
          
          return Disposables.create { task.cancel() }
        }
          .asObservable()
          .map { return .setItem($0)},
        
          .just(.setLoading(true)),
      ])
    case .logout:
      return Observable.concat([
        .just(.setLoading(false)),
        Single.create { observer in
          let task = Task {
            do {
              // TODO: 실제토큰으로 호출
//              try await self.userRepo.logout()
              observer(.success(()))
            } catch {
              observer(.failure(error))
            }
          }
          
          return Disposables.create { task.cancel() }
        }
          .asObservable()
          .map { _ in return .setDestination(.login)}
        ,
        .just(.setLoading(true))
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
      
    case let .setDestination(value):
      newState.destination = value
    }
    
    return newState
  }
}
