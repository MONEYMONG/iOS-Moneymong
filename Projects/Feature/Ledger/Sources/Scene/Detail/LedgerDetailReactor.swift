import AgencyInterface
import BaseFeature
import LedgerFeatureInterface
import BaseDomain
import LedgerInterface
import Utility

import ReactorKit

final class LedgerDetailReactor: Reactor {

  enum Action {
    case onAppear
    case didTapDelete
    case didTapEdit
  }

  enum Mutation {
    case setLedger(LedgerDetail)
    case setError(MoneyMongError)
    case setIsLoading(Bool)
    case setIsEdit(Bool)
    case setDeleteCompleted(Void)
    case setIsValid(Bool)
    case setDestination(State.Destination)
  }

  struct State {
    let agencyID: Int
    let ledgerId: Int
    @Pulse var role: Member.Role
    @Pulse var ledger: LedgerDetail?
    @Pulse var error: MoneyMongError?
    @Pulse var isLoading: Bool?
    @Pulse var isEdit: Bool = false
    @Pulse var isValid: Bool?
    @Pulse var deleteCompleted: Void?
    @Pulse var destination: Destination?

    enum Destination {
      case categorySheet(agencyID: Int, categories: [MMCategory])
    }
  }

  var initialState: State
  private let ledgerService: LedgerServiceInterface
  private(set) var ledgerContentsService: LedgerDetailContentsServiceInterface
  
  private let getLedgerDetailUseCase: GetLedgerDetailUseCaseInterface
  private let deleteLedgerUseCase: DeleteLedgerUseCaseInterface
  private let getCategoriesUseCase: GetCategoriesUseCaseInterface

  init(
    agencyID: Int,
    ledgerID: Int,
    role: Member.Role,
    getLedgerDetailUseCase: GetLedgerDetailUseCaseInterface,
    deleteLedgerUseCase: DeleteLedgerUseCaseInterface,
    getCatagoriesUseCase: GetCategoriesUseCaseInterface = DIContainer.shared.resolve(type: GetCategoriesUseCaseInterface.self),
    ledgerService: LedgerServiceInterface,
    ledgerContentsService: LedgerDetailContentsServiceInterface
  ) {
    self.initialState = State(agencyID: agencyID, ledgerId: ledgerID, role: role)
    self.getLedgerDetailUseCase = getLedgerDetailUseCase
    self.deleteLedgerUseCase = deleteLedgerUseCase
    self.getCategoriesUseCase = getCatagoriesUseCase
    self.ledgerService = ledgerService
    self.ledgerContentsService = ledgerContentsService
  }

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    return Observable.merge(mutation, serviceMutation)
  }

  private var serviceMutation: Observable<Mutation> {
    return ledgerContentsService.contentsViewEvent
      .withUnretained(self)
      .flatMap { owner, mutation -> Observable<Mutation> in
        switch mutation {
        case .isValidChanged(let value):
          return .just(.setIsValid(value))
        case .isLoading(let value):
          return .just(.setIsLoading(value))
        case let .showCategorySheet(categories):
          return .just(.setDestination(.categorySheet(
            agencyID: owner.currentState.agencyID,
            categories: categories
          )))
        }
      }
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {

    case .onAppear:
      return .concat([
        .just(.setIsLoading(true)),
        .task {
          let ledgerDetail = try await getLedgerDetailUseCase.execute(id: currentState.ledgerId)
          ledgerContentsService.setLedger(ledgerDetail)
          return ledgerDetail
        }
          .map { .setLedger($0) }
          .catch { return .just(.setError($0.toMMError))},
        .just(.setIsLoading(false)),
        .task {
          let categories = try await getCategoriesUseCase.execute(id: currentState.agencyID)
          ledgerContentsService.parentViewEvent.onNext(.setCategories(.success(categories)))
          return ()
        }
          .flatMap { Observable.empty() }
          .catch { [weak self] in
            self?.ledgerContentsService.parentViewEvent.onNext(.setCategories(.failure($0.toMMError)))
            return .empty()
          },
      ])

    case .didTapDelete:
      return .concat([
        .just(.setIsLoading(true)),

          .task { return try await deleteLedgerUseCase.execute(id: currentState.ledgerId) }
          .map { [weak self] in self?.ledgerService.ledgerList.updateList() }
          .map { .setDeleteCompleted(()) }
          .catch { return .just(.setError($0.toMMError))},

          .just(.setIsLoading(false))
      ])

    case .didTapEdit:
      ledgerContentsService.shouldTypeChanged(to: currentState.isEdit ? .read : .update)
      return .just(.setIsEdit(!(currentState.isEdit)))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setLedger(let ledger):
      newState.ledger = ledger
    case .setIsLoading(let isLoading):
      newState.isLoading = isLoading
    case .setIsEdit(let isEdit):
      newState.isEdit = isEdit
    case .setDeleteCompleted(let event):
      newState.deleteCompleted = event
    case .setIsValid(let value):
      newState.isValid = value
    case .setError(let error):
      newState.error = error
    case let .setDestination(destination):
      newState.destination = destination
    }
    return newState
  }
}
