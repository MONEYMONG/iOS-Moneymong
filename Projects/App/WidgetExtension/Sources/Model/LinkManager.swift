import Foundation

enum LinkManager {
  case ledgerDetail
  case createLedger
  
  var url: URL {
    let urlString: String
    switch self {
    case .ledgerDetail: urlString = "widget://LedgerDetail"
    case .createLedger: urlString = "widget://CreateLedger"
    }
    return URL(string: urlString)!
  }
}
