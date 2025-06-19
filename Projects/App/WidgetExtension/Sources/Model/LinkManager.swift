import Foundation

enum LinkManager {
  case ledgerDetail
  case createLedger
  case createAgency
  
  var url: URL {
    let urlString: String
    switch self {
    case .ledgerDetail: urlString = "widget://LedgerDetail"
    case .createLedger: urlString = "widget://CreateLedger"
    case .createAgency: urlString = "widget://CreateAgency"
    }
    return URL(string: urlString)!
  }
}
