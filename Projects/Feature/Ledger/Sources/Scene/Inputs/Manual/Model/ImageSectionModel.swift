import Foundation

import RxDataSources

struct ImageSectionModel {
  typealias Model = SectionModel<Section, Item>
  
  enum Section: Int, Equatable {
    case receipt
    case document
  }

  enum Item: Equatable {
    case button(_ section: Section)
    case image(_ info: ImageInfo, _ section: Section)
  }
  
  let model: Section
  var items: [Item]
}
