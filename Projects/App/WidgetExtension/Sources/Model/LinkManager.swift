import Foundation

enum LinkManager {
  case ocr
  case ledgerDetail
  case createLedger
  
  var url: URL {
    let urlString: String
    switch self {
    case .ocr: urlString = "widget://OCR"
    case .ledgerDetail: urlString = "widget://LedgerDetail"
    case .createLedger: urlString = "widget://CreateLedger"
    }
    return URL(string: urlString)!
  }
}
