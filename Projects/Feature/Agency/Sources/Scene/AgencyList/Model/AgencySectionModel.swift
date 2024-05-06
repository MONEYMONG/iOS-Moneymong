import Foundation

import NetworkService

import RxDataSources

struct AgencySectionModel {
  var id = UUID()
  var items: [Item]
}

extension AgencySectionModel: AnimatableSectionModelType {
  typealias Item = Agency
  
  var identity: UUID {
    return id
  }
  
  init(original: AgencySectionModel, items: [Agency]) {
    self = original
    self.items = items
  }
}

extension Agency: IdentifiableType {
  public var identity: Int { return id }
}
