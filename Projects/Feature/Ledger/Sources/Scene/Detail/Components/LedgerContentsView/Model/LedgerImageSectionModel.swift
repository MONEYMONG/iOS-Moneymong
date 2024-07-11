import Core

import RxDataSources


struct LedgerImageSectionModel {
  typealias Model = SectionModel<Section, Item>

  enum Section: Equatable {
    case `default`(String)
  }

  enum Item: Equatable {
    case description(String)
    case imageAddButton
    case image(LedgerImageInfo)
  }

  let model: Section
  var items: [Item]
}
