import Foundation

import NetworkService

import RxDataSources

struct LedgerSectionModel {
  var id = UUID()
  var items: [Item]
}

extension LedgerSectionModel: AnimatableSectionModelType {
  typealias Item = Ledger
  
  var identity: UUID {
    return id
  }
  
  init(original: LedgerSectionModel, items: [Ledger]) {
    self = original
    self.items = items
  }
}

extension Ledger: IdentifiableType {
  public var identity: Int { return id }
}

