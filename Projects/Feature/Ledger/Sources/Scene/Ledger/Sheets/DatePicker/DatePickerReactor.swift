import ReactorKit

final class DatePickerReactor: Reactor {
  enum Action {
    case viewWillAppear
    case selectDateLabel(PickerState)
    case selectDate(Int, Int)
    case didTapCompleteButton
  }

  enum Mutation {
    case setDateType(PickerState)
    case setYear(Int)
    case setMonth(Int)
    case setPickerRow
    case setDestination
  }

  struct State {
    @Pulse var selectedDateType: PickerState = .start
    @Pulse var pickerRow: (Int, Int)?
    @Pulse var startDate: DateInfo
    @Pulse var endDate: DateInfo
    @Pulse var isWarning = false
    @Pulse var destination: Destination?
    
    enum Destination {
      case ledger
      case showSnackBar
    }
  }
  
  var yearList: [Int] = Array(2015...2024).reversed()
  var monthList: [Int] = Array(1...12).reversed()
  
  enum PickerState {
    case start
    case end
  }

  let initialState: State

  init(startDate: DateInfo, endDate: DateInfo) {
    self.initialState = State(
      startDate: startDate,
      endDate: endDate
    )
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
      return .just(.setDestination)
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
    case .setDestination:
      if checkDate(startDate: state.startDate, endDate: state.endDate) {
        newState.destination = .showSnackBar
      } else {
        newState.destination = .ledger
      }
    }
    if newState.selectedDateType == .end {
      newState.isWarning = checkDate(
        startDate: newState.startDate,
        endDate: newState.endDate
      )
    }
    return newState
  }
  
  func checkDate(startDate: DateInfo, endDate: DateInfo) -> Bool {
    if startDate.year > endDate.year {
      return true
    } else if startDate.year == endDate.year && startDate.month > endDate.month {
      return true
    }
    return false
  }
}
