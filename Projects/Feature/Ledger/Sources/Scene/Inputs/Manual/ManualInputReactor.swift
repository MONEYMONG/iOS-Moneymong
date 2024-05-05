import Foundation

import NetworkService

import ReactorKit

final class ManualInputReactor: Reactor {
  private let repo: LedgerRepositoryInterface
    
  enum ContentType {
    case source
    case amount
    case fundType
    case date
    case time
    case memo
  }
  
  enum Action {
    case didTapCompleteButton
    case didTapImageDeleteButton(_ item: ImageSectionModel.Item)
    case didTapImageAddButton(_ section: ImageSectionModel.Section)
    case selectedImage(_ item: ImageSectionModel.Item)
    case inputContent(_ value: String, type: ContentType)
  }
  
  enum Mutation {
    case addImage(Result<ImageSectionModel.Item, MoneyMongError>)
    case deleteImage(Result<(UUID, ImageSectionModel.Section) ,MoneyMongError>)
    case deleteImageURL(Int, ImageSectionModel.Section)
    case setContent(_ value: String, type: ContentType)
    case setSection(_ section: ImageSectionModel.Section)
    case addImageURL(_ image: ImageURL, _ section: ImageSectionModel.Section)
    case requestCreateAPI(Result<Void, MoneyMongError>)
  }
  
  struct State {
    @Pulse var agencyId: Int
    @Pulse var images: [ImageSectionModel.Model] = [
      .init(model: .receipt, items: [.button(.receipt)]),
      .init(model: .document, items: [.button(.document)])
    ]
    @Pulse var selectedSection: ImageSectionModel.Section? = nil
    @Pulse var isCompleted = false
    @Pulse var alertMessage: (String, String?)? = nil
    @Pulse var isValids: [ContentType: Bool?] = [
      .source: nil,
      .amount: nil,
      .fundType: nil,
      .date: nil,
      .time: nil,
      .memo: nil
    ]
    var content = Content()
  }
  
  struct Content {
    @Pulse var source: String = ""
    @Pulse var amount: String = ""
    @Pulse var amountSign: Int = -1
    @Pulse var date: String = ""
    @Pulse var time: String = ""
    @Pulse var memo: String = ""
    @Pulse var receiptImageURLs = [ImageURL]()
    @Pulse var documentImageURLs = [ImageURL]()
  }
    
  private let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
  }()
  
  init(repo: LedgerRepositoryInterface) {
    self.repo = repo
    self.initialState = State(agencyId: 19)
  }
  
  let initialState: State
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .selectedImage(let item):
      guard case let .image(imageInfo, section) = item else { return .empty() }
      return .task {
        var entity = try await repo.imageUpload(imageInfo.data)
        entity.id = imageInfo.id
        return entity
      }
      .flatMap { Observable<Mutation>.concat([
        .just(.addImage(.success(item))),
        .just(.addImageURL($0, section))
      ]) }
      .catch { .just(.addImage(.failure($0.toMMError))) }
    case .didTapImageDeleteButton(let item):
      guard case let .image(image, section) = item else { return .empty() }
      return .task {
        var index: Int!
        var imageURL: ImageURL!
        switch section {
        case .receipt:
          index = currentState.content.receiptImageURLs.firstIndex(where: {
            $0.id == image.id
          })
          imageURL = currentState.content.receiptImageURLs[index]
        case .document:
          index = currentState.content.documentImageURLs.firstIndex(where: {
            $0.id == image.id
          })
          imageURL = currentState.content.documentImageURLs[index]
        }
        try await repo.imageDelete(imageURL)
        return index
      }
      .flatMap { Observable<Mutation>.concat([
        .just(.deleteImage(.success((image.id, section)))),
        .just(.deleteImageURL($0, section))
      ]) }
      .catch { .just(.deleteImage(.failure($0.toMMError))) }
    case .didTapImageAddButton(let section):
      return .just(.setSection(section))
    case .inputContent(let value, let type):
      return .just(.setContent(value, type: type))
    case .didTapCompleteButton:
      return .task {
        guard let amount = Int(currentState.content.amount.filter { $0.isNumber }) else {
          throw MoneyMongError.appError(errorMessage: "금액을 확인해 주세요")
        }
        guard let date = convertDateString(currentState.content.date + " " + currentState.content.time) else {
          throw MoneyMongError.appError(errorMessage: "날짜 및 시간을 확인해 주세요")
        }
        return try await repo.create(
          id: currentState.agencyId,
          storeInfo: currentState.content.source,
          fundType: currentState.content.amountSign == 1 ? .income : .expense,
          amount: amount,
          description: currentState.content.memo,
          paymentDate: date,
          receiptImageUrls: currentState.content.receiptImageURLs.map(\.url),
          documentImageUrls: currentState.content.documentImageURLs.map(\.url)
        )
      }
      .map { .requestCreateAPI(.success(())) }
      .catch {
        return .just(.requestCreateAPI(.failure($0.toMMError)))
      }
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    newState.selectedSection = nil
    newState.alertMessage = nil
    switch mutation {
    case .addImage(let result):
      switch result {
      case .success(let item):
        guard case let .image(_, section) = item else { return newState }
        newState.images[section.rawValue].items.append(item)
        if newState.images[section.rawValue].items.count > 12 {
          newState.images[section.rawValue].items.removeFirst()
        }
      case .failure(let failure):
        newState.alertMessage = ("에러", failure.errorDescription)
      }
    case .deleteImage(let result):
      switch result {
      case .success((let id, let section)):
        newState.images[section.rawValue].items.removeAll {
          guard case let .image(model, _) = $0 else { return false }
          return model.id == id
        }
        if !newState.images[section.rawValue].items.contains(.button(section)) {
          newState.images[section.rawValue].items.insert(.button(section), at: 0)
        }
      case .failure(let failure):
        newState.alertMessage = ("에러", failure.errorDescription)
      }
      
    case .setSection(let section):
      newState.selectedSection = section
    case .setContent(let value, let type):
      setContent(&newState.content, value: value, type: type)
      newState.isValids[type] = checkContent(newState.content, type: type)
    case .requestCreateAPI(let result):
      switch result {
      case .success(_):
        newState.isCompleted = true
      case .failure(let failure):
        newState.alertMessage = ("에러", failure.errorDescription)
      }
    case .addImageURL(let imageURL, let section):
      switch section {
      case .receipt:
        newState.content.receiptImageURLs.append(imageURL)
      case .document:
        newState.content.documentImageURLs.append(imageURL)
      }
    case .deleteImageURL(let index, let section):
      switch section {
      case .receipt:
        newState.content.receiptImageURLs.remove(at: index)
      case .document:
        newState.content.documentImageURLs.remove(at: index)
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
      content.amount = formatAmount(value) ?? ""
    case .fundType:
      content.amountSign = Int(value)!
    case .date:
      content.date = formatDate(value)
    case .time:
      content.time = formatItme(value)
    case .memo:
      content.memo = value
    }
  }
  
  func checkContent(_ content: Content, type: ContentType) -> Bool? {
    var pattern: String!
    var value: String!
    switch type {
    case .source:
      if content.source.isEmpty { return nil }
      return content.source.count <= 20
    case .amount:
      if content.amount.isEmpty { return nil }
      return Int(content.amount.replacingOccurrences(of: ",", with: ""))! <= 999999999
    case .fundType:
      return content.amountSign == 1 || content.amountSign == 0
    case .date:
      pattern = "^\\d{4}/(0[1-9]|1[012])/(0[1-9]|[12]\\d|3[01])$"
      value = content.date
    case .time:
      pattern = "^([01]?[0-9]|2[0-3]):[0-5][0-9](:[0-5][0-9])?$"
      value = content.time
    case .memo:
      if content.memo.isEmpty { return nil }
      return content.memo.count <= 300
    }
    
    let regex = try! NSRegularExpression(pattern: pattern)
    let result = regex.firstMatch(in: value, range: NSRange(location: 0, length: value.count))

    return result != nil
  }
  
  func formatAmount(_ value: String) -> String? {
    guard let num = Int(value.filter { $0.isNumber }) else { return nil }
    return numberFormatter.string(from: NSNumber(value: num))
  }
  
  func formatDate(_ value: String) -> String {
    var dateString = value
    if value.last == "/" {
      dateString.removeLast()
      return dateString
    }
    
    var dateArray = Array(dateString)
    
    if dateArray.count == 5 {
      dateArray.insert("/", at: 4)
    } else if dateArray.count == 8 {
      dateArray.insert("/", at: 7)
    }
    
    return String(dateArray)
  }
  
  func formatItme (_ value: String) -> String {
    var timeString = value
    if value.last == ":" {
      timeString.removeLast()
      return timeString
    }
    
    var timeArray = Array(timeString)
    
    if timeArray.count == 3 {
      timeArray.insert(":", at: 2)
    } else if timeArray.count == 6 {
      timeArray.insert(":", at: 5)
    }
    
    return String(timeArray)
  }
  
  func convertDateString(_ dateString: String) -> String? {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "YYYY/MM/DD HH:mm:ss"
    inputFormatter.timeZone = TimeZone(abbreviation: "UTC")
    guard let date = inputFormatter.date(from: dateString) else { return nil }
    let outputFormatter = ISO8601DateFormatter()
    outputFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    outputFormatter.timeZone = TimeZone(abbreviation: "UTC")
    let isoDateString = outputFormatter.string(from: date)
    return isoDateString
  }
}

public extension Observable {
  static func task<T>(@_implicitSelfCapture _ c: @escaping () async throws -> T) -> Observable<T> {
    return Single<T>.create { single in
      let task = Task {
        do {
          let result = try await c()
          single(.success(result))
        } catch {
          single(.failure(error))
        }
      }
      return Disposables.create {
        task.cancel()
      }
    }
    .asObservable()
  }
}
