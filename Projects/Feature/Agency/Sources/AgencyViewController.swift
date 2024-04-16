import UIKit

import BaseFeature
import ReactorKit
import PinLayout
import FlexLayout

public final class AgencyViewController: BaseVC, View {
  public var disposeBag = DisposeBag()
  weak var coordinator: AgencyCoordinator?

  public func bind(reactor: AgencyReactor) {
    view.backgroundColor = .red
  }
}

public final class AgencyReactor: Reactor {

  public enum Action {

  }

  public enum Mutation {

  }

  public struct State {

  }

  public let initialState: State = State()

  init() {

  }
}
