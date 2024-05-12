import UIKit

import DesignSystem
import BaseFeature
import NetworkService

import ReactorKit

final class MemberTabVC: BaseVC, View {
  var disposeBag = DisposeBag()
  
  private let profileHeaderLabel: UILabel = {
    let v = UILabel()
    v.font = Fonts.body._3
    v.textColor = Colors.Gray._10
    v.setTextWithLineHeight(text: "나", lineHeight: 20)
    return v
  }()
  
  private let profileView = MyProfileView()
  
  private let memberHeaderLabel: UILabel = {
    let v = UILabel()
    v.font = Fonts.body._3
    v.textColor = Colors.Gray._10
    v.setTextWithLineHeight(text: "맴버 목록", lineHeight: 20)
    return v
  }()
  
  override func setupUI() {
    super.setupUI()
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    rootContainer.flex.paddingHorizontal(20).define { flex in
      flex.addItem(profileHeaderLabel).marginTop(24).marginBottom(8)
      flex.addItem(profileView).marginBottom(24)
      flex.addItem(memberHeaderLabel)
    }
  }
  
  func bind(reactor: MemberTabReactor) {
    // Action
    rx.viewDidAppear
      .map { Reactor.Action.onappear }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    profileView.tapCopy
      .bind {
        guard let code = reactor.currentState.invitationCode else { return }
        UIPasteboard.general.string = code
        SnackBarManager.show(title: "초대코드 \(code)이 복사되었습니다")
      }
      .disposed(by: disposeBag)
    
    profileView.tapReissue
      .map { Reactor.Action.reissueInvitationCode }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // State
    
    reactor.pulse(\.$invitationCode)
      .compactMap { $0 }
      .skip(1)
      .observe(on: MainScheduler.instance)
      .bind { _ in
        SnackBarManager.show(title: "초대코드가 재발급 되었습니다.")
      }
      .disposed(by: disposeBag)
    
    Observable.combineLatest(
      reactor.pulse(\.$name),
      reactor.pulse(\.$invitationCode),
      reactor.pulse(\.$role)
    )
    .compactMap { element -> (name: String, code: String, role: Member.Role)? in
      guard let name = element.0, let code = element.1, let role = element.2 else { return nil }
      return (name: name, code: code, role: role)
    }
    .observe(on: MainScheduler.instance)
    .bind(with: self) { owner, element in
      print(element.name, element.code, element.role)
      owner.profileView.configure(title: element.name, role: element.role, code: element.code)
    }
    .disposed(by: disposeBag)
  }
}
