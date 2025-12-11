import AgencyInterface
import LedgerFeatureInterface
import BaseDomain
import BaseFeature

import ReactorKit

final class CategoryReactor: Reactor {
  enum Action {
    case didTapDeleteButton(Int)
    case didTapCreateButton
  }
  
  enum Mutation {
    case deleteCategory(Int)
    case setDestination(State.Destination)
    case setCategories([MMCategory])
  }
  
  struct State {
    @Pulse var categories: [MMCategory]
    @Pulse var destination: Destination?
    
    enum Destination {
      case createCategory(agencyId: Int)
    }
  }
  
  let initialState: State
  private let agencyId: Int
  private let service: LedgerServiceInterface
  private let deleteCategoryUseCase: DeleteCategoryUseCaseInterface
  
  init(
    agencyId: Int,
    categories: [MMCategory],
    service: LedgerServiceInterface = DIContainer.shared.resolve(type: LedgerServiceInterface.self),
    deleteCategoryUseCase: DeleteCategoryUseCaseInterface = DIContainer.shared.resolve(type: DeleteCategoryUseCaseInterface.self)
  ) {
    self.agencyId = agencyId
    self.initialState = State(
      categories: categories
    )
    self.service = service
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
    case .didTapCreateButton:
      return .just(.setDestination(.createCategory(agencyId: agencyId)))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .deleteCategory(index):
      newState.categories.remove(at: index)
    case let .setDestination(destination):
      newState.destination = destination
    case let .setCategories(categories):
      newState.categories = categories
    }
    return newState
  }
  
  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    return Observable.merge(mutation, serviceMutation())
  }
  
  private func serviceMutation() -> Observable<Mutation> {
    return service.category.event
      .withUnretained(self)
      .flatMap { owner, event -> Observable<Mutation> in
        switch event {
        case let .update(categories):
          return .just(.setCategories(categories))
        }
      }
  }
}

