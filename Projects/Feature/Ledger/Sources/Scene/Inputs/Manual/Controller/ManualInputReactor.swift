import Foundation

import NetworkService

import ReactorKit

final class ManualInputReactor: Reactor {
  enum ContentType {
    case source
    case amount
    case fundType
    case date
    case time
    case memo
  }
  
  enum AlertType {
    case error(MoneyMongError)
    case deleteImage(ImageSectionModel.Item)
    case end
  }
  
  enum Action {
    case onAppear
    case didTapCompleteButton
    case presentedAlert(AlertType)
    case didTapImageDeleteAlertButton(_ item: ImageSectionModel.Item)
    case didTapImageAddButton(_ section: ImageSectionModel.Section)
    case selectedImage(_ item: ImageSectionModel.Item)
    case inputContent(_ value: String, type: ContentType)
  }
  
  enum Mutation {
    case setName(String)
    case addImage(ImageSectionModel.Item)
    case deleteImage(UUID, ImageSectionModel.Section)
    case deleteImageURL(Int, ImageSectionModel.Section)
    case setContent(_ value: String, type: ContentType)
    case setSection(_ section: ImageSectionModel.Section)
    case addImageURL(_ image: ImageInfo, _ section: ImageSectionModel.Section)
    case setDestination
    case setAlertContent(AlertType)
  }
  
  struct State {
    let agencyId: Int
    @Pulse var userName: String = ""
    @Pulse var images: [ImageSectionModel.Model] = [
      .init(model: .receipt, items: [.button(.receipt)]),
      .init(model: .document, items: [.button(.document)])
    ]
    @Pulse var selectedSection: ImageSectionModel.Section? = nil
    @Pulse var alertMessage: (String, String?, AlertType)? = nil
    @Pulse var isButtonEnabled = false
    @Pulse var destination: Destination?
    var content = Content()
    
    enum Destination {
      case ledger
    }
  }
  
  struct Content {
    @Pulse var source: String = ""
    @Pulse var amount: String = ""
    @Pulse var amountSign: Int = -1
    @Pulse var date: String = ""
    @Pulse var time: String = ""
    @Pulse var memo: String = ""
    @Pulse var receiptImages = [ImageInfo]()
    @Pulse var documentImages = [ImageInfo]()
  }
  
  let initialState: State
  private let service: LedgerServiceInterface
  private let ledgerRepo: LedgerRepositoryInterface
  private let userRepo: UserRepositoryInterface
  private let formatter = ContentFormatter()
  
  init(
    agencyId: Int,
    ledgerRepo: LedgerRepositoryInterface,
    userRepo: UserRepositoryInterface,
    ledgerService: LedgerServiceInterface
  ) {
    self.ledgerRepo = ledgerRepo
    self.userRepo = userRepo
    self.service = ledgerService
    self.initialState = State(agencyId: agencyId)
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .onAppear:
      return .task { try await userRepo.user().nickname }
        .map { .setName($0) }
    case .selectedImage(let item):
      guard case let .image(imageInfo, section) = item else { return .empty() }
      return .task {
        var entity = try await ledgerRepo.imageUpload(imageInfo.data)
        entity.id = imageInfo.id
        return entity
      }
      .flatMap { Observable<Mutation>.concat([
        .just(.addImage(item)),
        .just(.addImageURL($0, section))
      ]) }
      .catch { .just(.setAlertContent(.error($0.toMMError))) }
    case .presentedAlert(let type):
        return .just(.setAlertContent(type))
    case .didTapImageDeleteAlertButton(let item):
      guard case let .image(image, section) = item else { return .empty() }
      return .task {
        var index: Int!
        var imageURL: ImageInfo!
        switch section {
        case .receipt:
          index = currentState.content.receiptImages.firstIndex(where: {
            $0.id == image.id
          })
          imageURL = currentState.content.receiptImages[index]
        case .document:
          index = currentState.content.documentImages.firstIndex(where: {
            $0.id == image.id
          })
          imageURL = currentState.content.documentImages[index]
        }
        try await ledgerRepo.imageDelete(imageURL)
        return index
      }
      .flatMap { Observable<Mutation>.concat([
        .just(.deleteImage(image.id, section)),
        .just(.deleteImageURL($0, section))
      ]) }
      .catch { .just(.setAlertContent(.error($0.toMMError))) }
    case .didTapImageAddButton(let section):
      return .just(.setSection(section))
    case .inputContent(let value, let type):
      return .just(.setContent(value, type: type))
    case .didTapCompleteButton:
      return .concat([
        requestCreateLedgerRecord(),
        service.ledgerList.createLedgerRecord().flatMap { _ in
          Observable<Mutation>.empty()
        }
      ])
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    newState.selectedSection = nil
    newState.alertMessage = nil
    switch mutation {
    case let .setName(name):
      newState.userName = name
      
    case .addImage(let item):
      guard case let .image(_, section) = item else { return newState }
      newState.images[section.rawValue].items.append(item)
      if newState.images[section.rawValue].items.count > 12 {
        newState.images[section.rawValue].items.removeFirst()
      }
    case .deleteImage(let id, let section):
        newState.images[section.rawValue].items.removeAll {
          guard case let .image(model, _) = $0 else { return false }
          return model.id == id
        }
        if !newState.images[section.rawValue].items.contains(.button(section)) {
          newState.images[section.rawValue].items.insert(.button(section), at: 0)
        }
    case .setSection(let section):
      newState.selectedSection = section
    case .setContent(let value, let type):
      setContent(&newState.content, value: value, type: type)
      newState.isButtonEnabled = checkContent(newState.content)
    case .setDestination:
      newState.destination = .ledger
    case .addImageURL(let imageURL, let section):
      switch section {
      case .receipt:
        newState.content.receiptImages.append(imageURL)
      case .document:
        newState.content.documentImages.append(imageURL)
      }
    case .deleteImageURL(let index, let section):
      switch section {
      case .receipt:
        newState.content.receiptImages.remove(at: index)
      case .document:
        newState.content.documentImages.remove(at: index)
      }
    case .setAlertContent(let type):
      switch type {
      case .error(let moneyMongError):
        newState.alertMessage = (moneyMongError.errorDescription!, nil, type)
      case .deleteImage(_):
        newState.alertMessage = ("사진을 삭제하시겠습니까?", "삭제된 사진은 되돌릴 수 없습니다", type)
      case .end:
        newState.alertMessage = ("정말 나가시겠습니까?", "작성한 내용이 저장되지 않았습니다", type)
      }
    }
    return newState
  }
}

private extension ManualInputReactor {
  func setContent(_ content: inout Content, value: String, type: ContentType) {
    switch type {
    case .source:
      content.source = value
    case .amount:
      content.amount = formatter.convertToAmount(with: value) ?? ""
    case .fundType:
      content.amountSign = Int(value)!
    case .date:
      content.date = formatter.convertToDate(with: value)
    case .time:
      content.time = formatter.convertToTime(with: value)
    case .memo:
      content.memo = value
    }
  }
  
  func checkContent(_ content: Content) -> Bool {
    // source
    guard content.source.isEmpty == false,
          content.source.count <= 20
    else {
      return false
    }
    
    // amount
    guard content.amount.isEmpty == false,
          let amount = Int(content.amount.replacingOccurrences(of: ",", with: "")),
          amount <= 999_999_999
    else {
      return false
    }

    // fund
    guard content.amountSign == 1 || content.amountSign == 0 else {
      return false
    }
    
    var pattern: String
    var value: String
    var regex: NSRegularExpression
    var result: NSTextCheckingResult?
    
    // date
    pattern = "^\\d{4}/(0[1-9]|1[012])/(0[1-9]|[12]\\d|3[01])$"
    value = content.date
    regex = try! NSRegularExpression(pattern: pattern)
    result = regex.firstMatch(in: value, range: NSRange(location: 0, length: value.count))
    guard result != nil else { return false }
    
    // time
    pattern = "^([01]?[0-9]|2[0-3]):[0-5][0-9](:[0-5][0-9])?$"
    value = content.time
    regex = try! NSRegularExpression(pattern: pattern)
    result = regex.firstMatch(in: value, range: NSRange(location: 0, length: value.count))
    guard result != nil else { return false }

    // memo
    guard content.memo.isEmpty == false,
          content.memo.count <= 300
    else {
      return false
    }
    
    return true
  }
  
  func requestCreateLedgerRecord() -> Observable<Mutation> {
    return .task {
      guard let amount = Int(currentState.content.amount.filter { $0.isNumber }) else {
        throw MoneyMongError.appError(errorMessage: "금액을 확인해 주세요")
      }
      guard let date = formatter.convertToISO8601(
        date: currentState.content.date,
        time: currentState.content.time
      )
      else {
        throw MoneyMongError.appError(errorMessage: "날짜 및 시간을 확인해 주세요")
      }
      return try await ledgerRepo.create(
        id: currentState.agencyId,
        storeInfo: currentState.content.source,
        fundType: currentState.content.amountSign == 1 ? .income : .expense,
        amount: amount,
        description: currentState.content.memo.isEmpty ? "내용없음" : currentState.content.memo,
        paymentDate: date,
        receiptImageUrls: currentState.content.receiptImages.map(\.url),
        documentImageUrls: currentState.content.documentImages.map(\.url)
      )}
      .map { .setDestination }
      .catch {
        return .just(.setAlertContent(.error($0.toMMError)))
      }
  }
}
