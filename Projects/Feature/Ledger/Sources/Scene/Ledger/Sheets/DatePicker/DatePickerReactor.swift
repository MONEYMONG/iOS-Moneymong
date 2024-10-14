import Core

import ReactorKit

final class DatePickerReactor: Reactor {
  enum Action {
    case onAppear
    case selectDateLabel(PickerState)
    case selectDate(row: Int, component: Int)
    case didTapCompleteButton
  }

  enum Mutation {
    case setDateType(PickerState)
    case setYear(Int)
    case setMonth(Int)
    case setPickerRow
    case setDestination(State.Destination)
  }

  struct State {
    @Pulse var selectedDateType: PickerState = .start
    @Pulse var pickerRow: (year: Int, month: Int)?
    @Pulse var startDate: DateInfo
    @Pulse var endDate: DateInfo
    @Pulse var isWarning = false
    @Pulse var destination: Destination?
    @Pulse var dateList: DateList
    
    enum Destination {
      case ledger
      case showSnackBar
    }
  }
  
  enum PickerState {
    case start
    case end
  }
  
  struct DateList {
    let year: [Int]
    let month: [Int]
  }

  let initialState: State
  private let service: LedgerServiceInterface

  init(
    startDate: DateInfo,
    endDate: DateInfo,
    ledgerService: LedgerServiceInterface,
    formatter: ContentFormatter
  ) {
    let currentYear = formatter.convertToDate(date: .now).split(separator: "/").map({ Int($0)! })[0]
    self.initialState = State(
      startDate: startDate,
      endDate: endDate,
      dateList: DateList(
        year: Array((currentYear - 15)...currentYear).reversed(),
        month: Array(1...12).reversed()
      )
    )
    self.service = ledgerService
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .onAppear:
      return .just(.setPickerRow)
    case .selectDateLabel(let type):
      return .concat([
        .just(.setDateType(type)),
        .just(.setPickerRow)
      ])
    case .selectDate(let row, let component):
      switch component {
      case 0: return 
          .concat([
            .just(.setYear(currentState.dateList.year[row])),
            .just(.setPickerRow)
          ])
      case 1: return 
          .concat([
            .just(.setMonth(currentState.dateList.month[row])),
            .just(.setPickerRow)
          ])
      default: return .empty()
      }
    case .didTapCompleteButton:
      if isDateRangeValid(
        startDate: currentState.startDate,
        endDate: currentState.endDate
      ) {
        return .merge([
          .just(.setDestination(.ledger)),
          service.ledgerList.selectedDate(
            start: currentState.startDate,
            end: currentState.endDate
          ).flatMap { Observable<Mutation>.empty() }
        ])
      } else {
        return .just(.setDestination(.showSnackBar))
      }
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    newState.isWarning = false
    newState.destination = nil
    switch mutation {
    case .setDateType(let type):
      newState.selectedDateType = type
    case .setPickerRow:
      switch state.selectedDateType {
      case .start:
        let yearRow = state.dateList.year.firstIndex(of: state.startDate.year)
        let monthRow = state.dateList.month.firstIndex(of: state.startDate.month)
        newState.pickerRow = (yearRow!, monthRow!)
      case .end:
        let yearRow = state.dateList.year.firstIndex(of: state.endDate.year)
        let monthRow = state.dateList.month.firstIndex(of: state.endDate.month)
        newState.pickerRow = (yearRow!, monthRow!)
      }
    case .setYear(let year):
      switch state.selectedDateType {
      case .start:
        newState.startDate = DateInfo(year: year, month: state.startDate.month)
      case .end:
        newState.endDate = DateInfo(year: year, month: state.endDate.month)
      }
    case .setMonth(let month):
      switch state.selectedDateType {
      case .start:
        newState.startDate = DateInfo(year: state.startDate.year, month: month)
      case .end:
        newState.endDate = DateInfo(year: state.endDate.year, month: month)
      }
    case let .setDestination(destination):
      newState.destination = destination
    }
    if newState.selectedDateType == .end {
      newState.isWarning = !isDateRangeValid(
        startDate: newState.startDate,
        endDate: newState.endDate
      )
    }
    return newState
  }
  
  func isDateRangeValid(startDate: DateInfo, endDate: DateInfo) -> Bool {
    if startDate.year > endDate.year {
      return false
    } else if startDate.year == endDate.year && startDate.month > endDate.month {
      return false
    }
    return true
  }
}
