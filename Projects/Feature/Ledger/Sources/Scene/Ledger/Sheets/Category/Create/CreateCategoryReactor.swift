import AgencyInterface
import BaseDomain
import BaseFeature

import ReactorKit

final class CreateCategoryReactor: Reactor {
  enum Action {}
  
  enum Mutation {}
  
  struct State {}
  
  let initialState: State
  
  init() {
    self.initialState = State()
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
   
    }
    return newState
  }
}

