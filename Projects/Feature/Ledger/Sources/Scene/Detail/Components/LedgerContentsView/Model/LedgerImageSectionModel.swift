import RxDataSources

struct LedgerImageSectionModel {
  typealias Model = SectionModel<Section, Item>

  enum Section: Equatable {
    case `default`(String)
  }

  enum Item: Equatable {
    case creatAdd
    case updateAdd
    case readImage(String)
    case updateImage
//    case button(Section)
//    case image(ImageData, Section)
  }

  let model: Section
  var items: [Item]
}
