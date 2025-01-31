import Repository

public final class MockWidgetRefreshController: WidgetRefreshable {
  public var refreshCallCount: Int = 0
  
  public func refresh() {
    refreshCallCount += 1
  }
}
