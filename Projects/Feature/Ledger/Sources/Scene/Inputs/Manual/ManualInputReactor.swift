import Foundation

import ReactorKit

final class ManualInputReactor: Reactor {
    
  enum ContentType {
    case source
    case amount
    case transactionType
    case date
    case time
  }
  
  enum Action {
    case selectedImage(_ item: ImageSectionModel.Item)
    case didTapImageDeleteButton(_ item: ImageSectionModel.Item)
    case didTapImageAddButton(_ section: ImageSectionModel.Section)
    case inputContent(_ value: String, type: ContentType)
  }
  
  enum Mutation {
    case addImage(_ image: ImageSectionModel.Item)
    case deleteImage(_ id: UUID, _ section: ImageSectionModel.Section)
    case setSection(_ section: ImageSectionModel.Section)
    case setContent(_ value: String, type: ContentType)
  }
  
  struct State {
    @Pulse var images: [ImageSectionModel.Model] = [
      .init(model: .receipt, items: [.button(.receipt)]),
      .init(model: .document, items: [.button(.document)])
    ]
    @Pulse var selectedSection: ImageSectionModel.Section? = nil
    var content = Content()
  }
  
  struct Content {
    @Pulse var source: String = ""
    @Pulse var amount: String = ""
    @Pulse var amountSign: Int = 1
    @Pulse var date: String = ""
    @Pulse var time: String = ""
  }
  
  let initialState: State = State()
  
  private let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
  }()
  
  init() {}
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .selectedImage(let item):
      return .just(.addImage(item))
    case .didTapImageDeleteButton(let item):
      guard case let .image(image, section) = item else { return .empty() }
      return .just(.deleteImage(image.id, section))
    case .didTapImageAddButton(let section):
      return .just(.setSection(section))
    case .inputContent(let value, let type):
      return .just(.setContent(value, type: type))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    newState.selectedSection = nil
    switch mutation {
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
      setContent(&newState, value: value, type: type)
    }
    return newState
  }
}

private extension ManualInputReactor {
  func setContent(_ state: inout State, value: String, type: ContentType) {
    switch type {
    case .source:
      state.content.source = value
    case .amount:
      state.content.amount = formatAmount(state, value) ?? ""
    case .transactionType:
      state.content.amountSign = Int(value)!
    case .date:
      state.content.date = formatDate(value)
    case .time:
      state.content.time = formatItme(value)
    }
  }
  
  func formatAmount(_ state: State, _ value: String) -> String? {
    var amountString = value
    let amountSet = Set(amountString)
    if amountSet.contains(",") {
      amountString = amountString.replacingOccurrences(of: ",", with: "")
    }
    guard let num = Int(amountString) else { return nil }
    return numberFormatter.string(for: num)
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
}
