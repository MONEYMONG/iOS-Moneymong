public final class MyPageDIContainer {
  public init() {}

  func myPage(with coordinator: MyPageCoordinator) -> MyPageVC {
    let vc = MyPageVC()
    vc.reactor = MyPageReactor()
    vc.coordinator = coordinator
    return vc
  }
}
