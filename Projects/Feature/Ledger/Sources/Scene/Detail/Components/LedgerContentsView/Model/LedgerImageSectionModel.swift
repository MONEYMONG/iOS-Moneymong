import RxDataSources

struct LedgerImageSectionModel {
  typealias Model = SectionModel<Section, Item>

  enum Section: Equatable {
    case `default`(String)
  }

  enum Item: Equatable {
    case description(String)
    case creatButton
    case updateButton
    case image(String)
  }

  let model: Section
  var items: [Item]
}
