import BaseDomain

import ReactorKit

final class CategoryReactor: Reactor {
  enum Action {
    case didTapDeleteButton(Int)
  }
  
  enum Mutation {
    case deleteCategory(Int)
  }
  
  struct State {
    @Pulse var categories: [MMCategory]
  }
  
  let initialState: State
  
  init(
    categories: [MMCategory],
  ) {
    self.initialState = State(
      categories: categories
    )
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .didTapDeleteButton(index):
      return .just(.deleteCategory(index))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .deleteCategory(index):
      newState.categories.remove(at: index)
    }
    return newState
  }
}

