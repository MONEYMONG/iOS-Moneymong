import ReactorKit

final class DatePickerReactor: Reactor {
  enum Action {
    case viewWillAppear
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
    
    enum Destination {
      case ledger(() -> Void)
      case showSnackBar
    }
  }
  
  var yearList: [Int] = Array(2010...2024).reversed()
  var monthList: [Int] = Array(1...12).reversed()
  
  enum PickerState {
    case start
    case end
  }

  let initialState: State
  private let service: LedgerServiceInterface

  init(
    startDate: DateInfo,
    endDate: DateInfo,
    ledgerService: LedgerServiceInterface
  ) {
    self.initialState = State(
      startDate: startDate,
      endDate: endDate
    )
    self.service = ledgerService
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewWillAppear:
      return .just(.setPickerRow)
    case .selectDateLabel(let type):
      return .concat([
        .just(.setDateType(type)),
        .just(.setPickerRow)
      ])
    case .selectDate(let row, let component):
      switch component {
      case 0: return .just(.setYear(yearList[row]))
      case 1: return .just(.setMonth(monthList[row]))
      default: return .empty()
      }
    case .didTapCompleteButton:
      let destination: State.Destination
      if isDateRangeValid(
        startDate: currentState.startDate,
        endDate: currentState.endDate
      ) {
        destination = .ledger { [weak self] in
          guard let self = self else { return }
          self.service.ledgerList.selectedDate(
            start: self.currentState.startDate,
            end: self.currentState.endDate
          )
        }
      } else {
        destination = .showSnackBar
      }
      return .just(.setDestination(destination))
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
        let yearRow = yearList.firstIndex(of: state.startDate.year)
        let monthRow = monthList.firstIndex(of: state.startDate.month)
        newState.pickerRow = (yearRow!, monthRow!)
      case .end:
        let yearRow = yearList.firstIndex(of: state.endDate.year)
        let monthRow = monthList.firstIndex(of: state.endDate.month)
        newState.pickerRow = (yearRow!, monthRow!)
      }
    case .setYear(let year):
      switch state.selectedDateType {
      case .start:
        newState.startDate.year = year
      case .end:
        newState.endDate.year = year
      }
    case .setMonth(let month):
      switch state.selectedDateType {
      case .start:
        newState.startDate.month = month
      case .end:
        newState.endDate.month = month
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
