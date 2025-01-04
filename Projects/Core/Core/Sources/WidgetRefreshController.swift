import WidgetKit

public protocol WidgetRefreshable {
  func refresh()
}

public final class WidgetRefreshController: WidgetRefreshable {
  public init() {}
  
  public func refresh() {
    WidgetCenter.shared.reloadAllTimelines()
  }
}
