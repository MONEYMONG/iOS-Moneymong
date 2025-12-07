import ReactorKit

final class CategoryReactor: Reactor {
  enum Action {
    case didTapDeleteButton(Int)
  }
  
  enum Mutation {
    case deleteCategory(Int)
  }
  
  struct State {
    @Pulse var categories: [String]
  }
  
  let initialState: State
  
  init(
    categories: [String],
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

