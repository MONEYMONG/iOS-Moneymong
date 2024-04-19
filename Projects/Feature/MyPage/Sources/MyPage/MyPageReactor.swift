import ReactorKit

public final class MyPageReactor: Reactor {

  public enum Action {

  }

  public enum Mutation {

  }

  public struct State {
    @Pulse var sections: [MyPageSection] = [.account, .setting]
    @Pulse var items: [[MyPageSectionItem]] = [[.university], [.service, .privacy, .withdrawl, .logout, .version]]
  }

  public let initialState: State = State()

  init() {

  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    return newState
  }
}
