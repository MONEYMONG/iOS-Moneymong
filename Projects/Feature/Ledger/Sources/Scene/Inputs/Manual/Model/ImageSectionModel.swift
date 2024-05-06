import Foundation

import RxDataSources

struct ImageSectionModel {
  typealias Model = SectionModel<Section, Item>
  
  enum Section: Int, Equatable {
    case receipt
    case document
  }

  enum Item: Equatable {
    case button(Section)
    case image(ImageData, Section)
  }
  
  let model: Section
  var items: [Item]
}
