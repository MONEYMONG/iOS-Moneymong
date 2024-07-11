import ReactorKit

import Core

public final class WithdrawalReactor: Reactor {
  public enum Action {
    case tapAgreementButton
    case tapWithdrawlButton
  }
  
  public enum Mutation {
    case setIsAgreee(Bool)
    case setLoading(Bool)
    case setDestination(State.Destination)
  }
  
  public struct State {
    @Pulse var isAgree = false
    @Pulse var isLoading = false
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
    case .tapAgreementButton:
      return .just(.setIsAgreee(!currentState.isAgree))
    case .tapWithdrawlButton:
      return .concat(
        .just(.setLoading(true)),
        
        .task { try await self.userRepo.withdrawl()}
        .map { _ in return .setDestination(.login)},
        
        .just(.setLoading(false)),
        .just(.setDestination(.login))
      )
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case let .setIsAgreee(value):
      newState.isAgree = value
    case let .setLoading(value):
      newState.isLoading = value
    case let .setDestination(value):
      newState.destination = value
    }
    
    return newState
  }
}
