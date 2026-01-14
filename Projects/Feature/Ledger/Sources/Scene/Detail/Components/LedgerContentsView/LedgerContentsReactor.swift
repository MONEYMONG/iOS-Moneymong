import UIKit

import AgencyInterface
import BaseDomain
import BaseFeature
import DesignSystem
import LedgerInterface
import LedgerFeatureInterface
import Utility

import ReactorKit

final class LedgerContentsReactor: Reactor {

  enum ContentType {
    case storeInfo(String, Bool)
    case amount(String, Bool)
    case fundType(FundType)
    case memo(String)
    case date(String, Bool)
    case time(String, Bool)
    case authorName(String)
    case documentImage(LedgerImageInfo, Bool)
    case category(String)
  }

  struct ContentValid {
    var isValidTitle = true
    var isValidAmount = true
    var isValidDate = true
    var isValidTime = true
  }

  enum Action {
    case didStateChanged(LedgerContentsView.State)
    case didValueChanged(ContentType)
    case selectedImage(Data)
    case deleteImage(LedgerImageInfo)
    case registrationLedger(LedgerDetail)
    case loadCategories(Result<[MMCategory], MoneyMongError>)
    case didTapCategoryEditButton
  }

  enum Mutation {
    case setLedger(LedgerDetailItem)
    case setValueChanged(ContentType)
    case setState(LedgerContentsView.State)
    case setError(MoneyMongError)
    case setCategories([MMCategory])
  }

  struct State {
    var prevLedgerItem: LedgerDetailItem = .empty
    @Pulse var currentLedgerItem: LedgerDetailItem = .empty
    @Pulse var error: MoneyMongError?
    @Pulse var state: LedgerContentsView.State = .read
    @Pulse var categories: [MMCategory] = []
  }

  var initialState = State()
  let formatter: ContentFormatter
  private let ledgerContentsService: LedgerDetailContentsServiceInterface
  private let ledgerService: LedgerServiceInterface
  
  private var valid = ContentValid()
  private var isValided: Bool {
    return valid.isValidTitle && valid.isValidAmount && valid.isValidDate && valid.isValidTime
  }

  private let updateLedgerUseCase: UpdateLedgerUseCaseInterface
  private let uploadImageUseCase: UploadImageUseCaseInterface
  private let uploadDocumentUseCase: UploadDocumentUseCaseInterface
  private let deleteDocumentUseCase: DeleteDocumentUseCaseInterface
  
  init(
    ledgerContentsService: LedgerDetailContentsServiceInterface,
    updateLedgerUseCase: UpdateLedgerUseCaseInterface,
    uploadImageUseCase: UploadImageUseCaseInterface,
    uploadDocumentUseCase: UploadDocumentUseCaseInterface,
    deleteDocumentUseCase: DeleteDocumentUseCaseInterface,
    formatter: ContentFormatter,
    ledgerService: LedgerServiceInterface = DIContainer.shared.resolve(type: LedgerServiceInterface.self)
  ) {
    self.ledgerContentsService = ledgerContentsService
    self.updateLedgerUseCase = updateLedgerUseCase
    self.uploadImageUseCase = uploadImageUseCase
    self.uploadDocumentUseCase = uploadDocumentUseCase
    self.deleteDocumentUseCase = deleteDocumentUseCase
    self.formatter = formatter
    self.ledgerService = ledgerService
  }

  func transform(action: Observable<Action>) -> Observable<Action> {
    return Observable.merge(action, serviceAction)
  }
  
  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    return Observable.merge(mutation, serviceMutation)
  }

  private var serviceAction: Observable<Action> {
    return ledgerContentsService.parentViewEvent
      .withUnretained(self)
      .flatMap { owner, action -> Observable<Action> in
        switch action {
        case .shouldTypeChanged(let state):
          return .just(.didStateChanged(state))
        case .setLedger(let ledger):
          return .just(.registrationLedger(ledger))
        case .setCategories(let result):
          return .just(.loadCategories(result))
        }
      }
  }
  
  private var serviceMutation: Observable<Mutation> {
    return ledgerService.category.event
      .withUnretained(self)
      .flatMap { owner, event -> Observable<Mutation> in
        switch event {
        case let .update(categories):
          return .just(.setCategories(categories))
        }
      }
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .registrationLedger(let ledger):
      return .just(.setLedger(.init(ledger: ledger)))

    case .didStateChanged(let state):
      // 변경사항이 있는경우
      if currentState.currentLedgerItem != currentState.prevLedgerItem {
        return .concat([
            .task {
              ledgerContentsService.setIsLoading(true)
              let ledger = try await updateLedgerUseCase.execute(request: currentState.currentLedgerItem.toEntity)
              ledgerContentsService.setIsLoading(false)
              return ledger
            }
            .map { .setLedger(.init(ledger: $0)) }
              .catch { [weak self] error in
                self?.ledgerContentsService.setIsLoading(false)
                return .just(.setError(error.toMMError))
              },

          .just(.setState(state))
        ])
        // 변경사항이 없는경우
      } else {
        return .just(.setState(state))
      }

    case .didValueChanged(let valueType):
      let convertedFormValue = setContentValueFormat(valueType)
      setValid(&valid, content: valueType)
      ledgerContentsService.didValidChanged(isValided)
      return .just(.setValueChanged(convertedFormValue))

    case .selectedImage(let data):
      return .task { return try await uploadImageUseCase.execute(imageData: data) }
        .map { imageInfo in
          return .setValueChanged(
            .documentImage(.init(key: imageInfo.key, url: imageInfo.url), true)
          )
        }
        .catch { [weak self] error in
          self?.ledgerContentsService.setIsLoading(false)
          return .just(.setError(error.toMMError))
        }

    case .deleteImage(let item):
      return .just(.setValueChanged(.documentImage(item, false)))
    case .loadCategories(let result):
      switch result {
      case .success(let categories):
          return .just(.setCategories(categories))
      case .failure(let error):
          return .just(.setError(error))
      }
    case .didTapCategoryEditButton:
      ledgerContentsService.contentsViewEvent.onNext(
        .showCategorySheet(
          categories: currentState.categories
        )
      )
      return .empty()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setValueChanged(let valueType):
      switch valueType {
      case let .storeInfo(storeInfo, _):
        newState.currentLedgerItem.storeInfo = storeInfo
        
      case let .amount(amount, _):
        newState.currentLedgerItem.amount = amount

      case .fundType(let fundType):
        newState.currentLedgerItem.fundType = fundType

      case .memo(let memo):
        newState.currentLedgerItem.memo = memo

      case let .date(date, _):
        newState.currentLedgerItem.date = date

      case let .time(time, _):
        newState.currentLedgerItem.time = time

      case .authorName(let authorName):
        newState.currentLedgerItem.authorName = authorName

      case .documentImage(let imageInfo, let isAdd):
        if isAdd {
          newState.currentLedgerItem.addImageItem(imageInfo: imageInfo)
        } else {
          newState.currentLedgerItem.deleteImageItem(imageInfo: imageInfo)
        }
        
      case .category(let category):
        newState.currentLedgerItem.category = newState.currentLedgerItem.category == category ? nil : category
      }

    case .setError(let error):
      newState.error = error

    case .setState(let state):
      switch state {
      case .read: newState.currentLedgerItem.setRead()
      case .update: newState.currentLedgerItem.setUpdate()
      }
      newState.state = state
      
    case .setLedger(let ledger):
      newState.prevLedgerItem = ledger
      newState.currentLedgerItem = ledger
      
    case .setCategories(let categories):
      newState.categories = categories
      if !categories.map(\.name).contains(state.currentLedgerItem.category) {
        newState.currentLedgerItem.category = nil
      }
    }

    return newState
  }
}

fileprivate extension LedgerContentsReactor {
  func registrationDocumentImages() async throws {
    if currentState.currentLedgerItem.addedDocumentImages.count > 0 {
      let id = currentState.currentLedgerItem.id
      let urls = currentState.currentLedgerItem.addedDocumentImages.map { $0.url }
      try await uploadDocumentUseCase.execute(ledgerID: id, documentUrls: urls)
    }
  }

  func deleteDocumentImages() async throws {
      let id = currentState.currentLedgerItem.id
      for imageInfo in currentState.currentLedgerItem.deletedDocumentImages {
        try await deleteDocumentUseCase.execute(ledgerID: id, documentID: Int(imageInfo.key) ?? 0)
      }
  }

  func setValid(_ valid: inout ContentValid, content: ContentType) {
    switch content {
    case let .storeInfo(value, isValid):
      valid.isValidTitle = isValid && !value.isEmpty
      
    case let .amount(value, isValid):
      valid.isValidAmount = isValid && !value.isEmpty
      
    case let .date(value, isValid):
      valid.isValidDate = isValid && !value.isEmpty
      
    case let .time(value, isValid):
      valid.isValidTime = isValid && !value.isEmpty
      
    default: break
    }
  }

  func setContentValueFormat(_ type: ContentType) -> ContentType {
    switch type {
    case .amount(let value, let isValid):
      return .amount(formatter.convertToAmount(with: value) ?? "", isValid)
    case .date(let value, let isValid):
      return .date(formatter.convertToDate(with: value, separator: "."), isValid)
    case .time(let value, let isValid):
      return .time(formatter.convertToTime(with: value), isValid)
    default: return type
    }
  }
}
