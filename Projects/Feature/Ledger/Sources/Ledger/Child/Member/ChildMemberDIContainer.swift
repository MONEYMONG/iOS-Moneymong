import BaseFeature

final class ChildMemberDIContainer {
  func childMember(with coordinator: Coordinator) -> ChildMemberVC {
    let vc = ChildMemberVC()
    vc.reactor = ChildMemberReactor()
    vc.coordinator = coordinator
    return vc
  }
}
