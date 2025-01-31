import WidgetKit

import BaseDomain

public final class WidgetRefreshController: WidgetRefreshable {
  public init() {}
  
  public func refresh() {
    WidgetCenter.shared.reloadAllTimelines()
  }
}
