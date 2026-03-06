import AgencyInterface
import BaseDomain
import BaseFeature
import LedgerFeatureInterface

import ReactorKit

final class CreateCategoryReactor: Reactor {
  enum Action {
    case inputTitle(String)
    case didTapRegisterButton
  }
  
  enum Mutation {
    case setTitle(String)
    case setDestination(State.Destination)
    case setTextFieldError(String)
  }
  
  struct State {
    @Pulse var title = ""
    @Pulse var destination: Destination?
    @Pulse var textFieldError: String?
    
    enum Destination {
      case before
    }
  }
  
  let initialState: State
  private let agencyId: Int
  private let service: LedgerServiceInterface
  private let createCategoryUseCase: CreateCategoryUseCaseInterface
  private let getCategoriesUseCase: GetCategoriesUseCaseInterface
  
  init(
    agencyId: Int,
    service: LedgerServiceInterface = DIContainer.shared.resolve(type: LedgerServiceInterface.self),
    createCategoryUseCase: CreateCategoryUseCaseInterface = DIContainer.shared.resolve(type: CreateCategoryUseCaseInterface.self),
    getCategoriesUseCase: GetCategoriesUseCaseInterface = DIContainer.shared.resolve(type: GetCategoriesUseCaseInterface.self)
  ) {
    self.agencyId = agencyId
    self.initialState = State()
    self.service = service
    self.createCategoryUseCase = createCategoryUseCase
    self.getCategoriesUseCase = getCategoriesUseCase
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .inputTitle(let title):
      return .just(.setTitle(title))
    case .didTapRegisterButton:
      return .task {
        try await createCategoryUseCase.execute(agencyId: agencyId, name: currentState.title)
        let categories = try await getCategoriesUseCase.execute(id: agencyId)
        service.category.event.onNext(.update(categories))
      }
      .map { .setDestination(.before) }
      .catch { error in
        return .just(.setTextFieldError(error.toMMError.errorTitle))
      }
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setTitle(let title):
      newState.title = title
    case let .setDestination(destination):
      newState.destination = destination
    case .setTextFieldError(let message):
      newState.textFieldError = message
    }
    return newState
  }
}

