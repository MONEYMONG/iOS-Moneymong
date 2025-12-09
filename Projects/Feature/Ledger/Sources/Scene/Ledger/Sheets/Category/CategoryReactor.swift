import AgencyInterface
import BaseDomain
import BaseFeature

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
  private let deleteCategoryUseCase: DeleteCategoryUseCaseInterface
  
  init(
    categories: [MMCategory],
    deleteCategoryUseCase: DeleteCategoryUseCaseInterface = DIContainer.shared.resolve(type: DeleteCategoryUseCaseInterface.self)
  ) {
    self.initialState = State(
      categories: categories
    )
    self.deleteCategoryUseCase = deleteCategoryUseCase
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .didTapDeleteButton(index):
      return .task {
        let categoryId = currentState.categories[index].id
        try await deleteCategoryUseCase.execute(id: categoryId)
      }
      .map { .deleteCategory(index) }
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

