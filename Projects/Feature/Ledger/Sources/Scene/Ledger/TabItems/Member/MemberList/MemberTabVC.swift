import UIKit

import DesignSystem
import BaseFeature
import NetworkService

import ReactorKit

final class MemberTabVC: BaseVC, View {
  var disposeBag = DisposeBag()
  weak var coordinator: LedgerCoordinator?
  
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
  
  private let tableView: UITableView = {
    let v = UITableView(frame: .zero, style: .plain)
    v.separatorStyle = .none
    v.register(MemberCell.self)
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
      flex.addItem(memberHeaderLabel).marginBottom(8)
      flex.addItem(tableView).grow(1)
    }
  }
  
  func bind(reactor: MemberTabReactor) {
    // Action
    rx.viewDidAppear
      .map { Reactor.Action.onappear }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    rx.viewDidAppear
      .bind {
        print(#function)
      }
      .disposed(by: disposeBag)
    
    profileView.tapCopy
      .do(onNext: {
        UIPasteboard.general.string = reactor.currentState.invitationCode
      })
      .map { Reactor.Action.tapCodeCopyButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    profileView.tapReissue
      .map { Reactor.Action.reissueInvitationCode }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    
    // State
    reactor.pulse(\.$members)
      .bind(to: tableView.rx.items) { [weak self] tableview, index, item in
        guard let role = reactor.currentState.role,
              let agencyID = reactor.currentState.agency?.id
        else { return UITableViewCell() }
        
        let cell = tableview.dequeue(MemberCell.self, for: IndexPath(index: index))
          
        cell.configure(member: item, role: role) { member in
          self?.coordinator?.present(.editMember(agencyID, member))
        }
        
        return cell
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$invitationCode)
      .distinctUntilChanged()
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
      owner.profileView.configure(title: element.name, role: element.role, code: element.code)
    }
    .disposed(by: disposeBag)
    
    reactor.pulse(\.$snackBarMessage)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind {
        SnackBarManager.show(title: $0)
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$destination)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, destination in
        switch destination {
        case let .kickOffAlert(memberID):
          owner.coordinator?.present(.alert(
            title: "정말 내보내시겠습니까?",
            subTitle: nil,
            type: .default(okAction: {
              reactor.action.onNext(.requestKickOffMember(memberID))
            }, cancelAction: {
              
            })
          ))
        }
      }
      .disposed(by: disposeBag)
  }
}