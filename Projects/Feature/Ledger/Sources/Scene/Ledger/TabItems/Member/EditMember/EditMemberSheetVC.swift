import UIKit

import DesignSystem

import ReactorKit
import RxSwift
import RxCocoa
import FlexLayout
import PinLayout

final class EditMemberSheetVC: BottomSheetVC, View {
  var disposeBag = DisposeBag()
  weak var coordinator: LedgerCoordinator?

  private let editMemberView = EditMemberListView()
  private let assignRoleView = AssignRoleView()

  override func setupConstraints() {
    super.setupConstraints()

    contentView.flex.define { flex in
      flex.addItem(editMemberView)
      flex.addItem(assignRoleView)
    }
    
    assignRoleView.flex.isIncludedInLayout(false).markDirty()
    assignRoleView.isHidden = true
  }
  
  func bind(reactor: EditMemberReactor) {
    editMemberView.tapRole
      .bind(with: self) { owner, _ in
        owner.editMemberView.flex.isIncludedInLayout(false).markDirty()
        owner.assignRoleView.flex.isIncludedInLayout(true).markDirty()
        owner.editMemberView.isHidden = true
        owner.assignRoleView.isHidden = false
        owner.view.setNeedsLayout()
      }
      .disposed(by: disposeBag)
    
    editMemberView.tapKickOff
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .map { _ in Reactor.Action.tapKickOut }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    assignRoleView.bind(role: reactor.currentState.member.role)
    
    assignRoleView.tapSave
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .map { Reactor.Action.tapSaveButton($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$error)
      .observe(on: MainScheduler.instance)
      .compactMap { $0 }
      .bind(with: self) { owner, error in
        owner.coordinator?.present(.alert(
          title: "네트워크 에러",
          subTitle: error.localizedDescription,
          type: .onlyOkButton({ })
        ))
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$destination)
      .observe(on: MainScheduler.instance)
      .compactMap { $0 }
      .bind(with: self) { owner, _ in
        owner.dismiss()
      }
      .disposed(by: disposeBag)
  }
}
