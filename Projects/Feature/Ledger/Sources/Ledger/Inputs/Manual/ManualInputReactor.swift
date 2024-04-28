import Foundation

import ReactorKit

final class ManualInputReactor: Reactor {
  
  enum ContentType {
    case source
    case amount
  }

  enum Action {
    case selectedImage(_ item: ImageSectionModel.Item)
    case didTapImageDeleteButton(_ item: ImageSectionModel.Item)
    case didTapImageAddButton(_ section: ImageSectionModel.Section)
  }

  enum Mutation {
    case addImage(_ image: ImageSectionModel.Item)
    case deleteImage(_ id: UUID, _ section: ImageSectionModel.Section)
    case setSection(_ section: ImageSectionModel.Section)
  }
  
  struct State {
    @Pulse var images: [ImageSectionModel.Model] = [
      .init(model: .receipt, items: [.button(.receipt)]),
      .init(model: .document, items: [.button(.document)])
    ]
    @Pulse var selectedSection: ImageSectionModel.Section? = nil
    @Pulse var source: String = ""
    @Pulse var amount: String = ""
  }

  let initialState: State = State()

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
    }
    return newState
  }
}
