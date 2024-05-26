import UIKit

import DesignSystem
import NetworkService
import BaseFeature

import ReactorKit

final class LedgerContentsReactor: Reactor {

  enum ContentType {
    case storeInfo(String)
    case amount(String)
    case fundType(FundType)
    case memo(String)
    case date(String)
    case time(String)
    case authorName(String)
  }

  enum Action {
    case didValueChanged(ContentType)
  }

  enum Mutation {
    case setValueChanged(ContentType)
  }

  struct State {
    let prevCurrentLedgerItem: LedgerDetailItem
    @Pulse var currentLedgerItem: LedgerDetailItem
  }

  var initialState: State
  private let formatter = ContentFormatter()
  private let ledgerDetailService: LedgerDetailContentsServiceInterface

  init(ledgerDetailService: LedgerDetailContentsServiceInterface, ledger: LedgerDetail?) {
    self.ledgerDetailService = ledgerDetailService
    self.initialState = State(
      prevCurrentLedgerItem: LedgerDetailItem(ledger: ledger, formatter: formatter),
      currentLedgerItem: LedgerDetailItem(ledger: ledger, formatter: formatter)
    )
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .didValueChanged(let valueType):
      let convertedFormValue = setContentValueFormat(valueType)
      return .just(.setValueChanged(convertedFormValue))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setValueChanged(let valueType):
      switch valueType {
      case .storeInfo(let storeInfo):
        ledgerDetailService.didValidChanged(!storeInfo.isEmpty)
        newState.currentLedgerItem.storeInfo = storeInfo
      case .amount(let amount):
        ledgerDetailService.didValidChanged(!amount.isEmpty)
        newState.currentLedgerItem.amount = amount
      case .fundType(let fundType):
        newState.currentLedgerItem.fundType = fundType
      case .memo(let memo):
        newState.currentLedgerItem.memo = memo
      case .date(let date):
        ledgerDetailService.didValidChanged(!date.isEmpty)
        newState.currentLedgerItem.date = date
      case .time(let time):
        ledgerDetailService.didValidChanged(!time.isEmpty)
        newState.currentLedgerItem.time = time
      case .authorName(let authorName):
        ledgerDetailService.didValidChanged(!authorName.isEmpty)
        newState.currentLedgerItem.authorName = authorName
      }
      
      /// 값이 변경되었는지 여부와 변경된 값
      ledgerDetailService.didValueChanged(
        isChanged: currentState.prevCurrentLedgerItem != currentState.currentLedgerItem,
        item: currentState.currentLedgerItem.toEntity
      )
    }

    return newState
  }
}

fileprivate extension LedgerContentsReactor {
  func setContentValueFormat(_ type: ContentType) -> ContentType {
    switch type {
    case .storeInfo(let value):
      return .storeInfo(value)
    case .amount(let value):
      return .amount(formatter.convertToAmount(with: value) ?? "")
    case .date(let value):
      return .date(formatter.convertToDate(with: value))
    case .time(let value):
      return .time(formatter.convertToTime(with: value))
    case .memo(let value):
      return .memo(value)
    case .fundType(let value):
      return .fundType(value)
    case .authorName(let value):
      return .authorName(value)
    }
  }

  //  func checkContent(_ content: Content, type: ContentType) -> Bool? {
  //    var pattern: String!
  //    var value: String!
  //    switch type {
  //    case .source:
  //      if content.source.isEmpty { return nil }
  //      return content.source.count <= 20
  //    case .amount:
  //      if content.amount.isEmpty { return nil }
  //      return Int(content.amount.replacingOccurrences(of: ",", with: ""))! <= 999999999
  //    case .fundType:
  //      return content.amountSign == 1 || content.amountSign == 0
  //    case .date:
  //      pattern = "^\\d{4}/(0[1-9]|1[012])/(0[1-9]|[12]\\d|3[01])$"
  //      value = content.date
  //    case .time:
  //      pattern = "^([01]?[0-9]|2[0-3]):[0-5][0-9](:[0-5][0-9])?$"
  //      value = content.time
  //    case .memo:
  //      if content.memo.isEmpty { return nil }
  //      return content.memo.count <= 300
  //    }
  //
  //    let regex = try! NSRegularExpression(pattern: pattern)
  //    let result = regex.firstMatch(in: value, range: NSRange(location: 0, length: value.count))
  //
  //    return result != nil
  //  }
}
