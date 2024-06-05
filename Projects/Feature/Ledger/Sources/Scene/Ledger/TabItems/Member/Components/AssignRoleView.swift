import UIKit

import NetworkService
import DesignSystem

import RxSwift
import RxCocoa
import FlexLayout
import PinLayout

final class AssignRoleView: UIView {

  private var disposeBag = DisposeBag()
  
  private let rootContainer = UIView()
  
  private let staffView = UIView()
  private let memberView = UIView()

  private let staffLabel: UILabel = {
    let v = UILabel()
    v.setTextWithLineHeight(text: "운영진", lineHeight: 24)
    v.font = Fonts.body._4
    v.textColor = Colors.Gray._5
    return v
  }()
  private let memberLabel: UILabel = {
    let v = UILabel()
    v.setTextWithLineHeight(text: "일반멤버", lineHeight: 24)
    v.font = Fonts.body._4
    v.textColor = Colors.Blue._4
    return v
  }()
  
  private let checkImageView = UIImageView(image: Images.check?.withTintColor(Colors.Gray._3))
  private let checkImageView2 = UIImageView(image: Images.check?.withTintColor(Colors.Blue._4))
  
  private let saveButton = MMButton(title: "저장", type: .primary)
  
  private var selectedRole: Member.Role = .member
  
  init() {
    super.init(frame: .zero)
    setupConstraints()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
  
  private func setupConstraints() {
    addSubview(rootContainer)
    rootContainer.flex.padding(20, 20, 46).define { flex in
      flex.addItem(staffView).direction(.row).alignItems(.center).define { flex in
        flex.addItem(staffLabel)
        flex.addItem().grow(1)
        flex.addItem(checkImageView).size(24)
      }.marginBottom(20)
      
      flex.addItem(memberView).direction(.row).alignItems(.center).define { flex in
        flex.addItem(memberLabel)
        flex.addItem().grow(1)
        flex.addItem(checkImageView2).size(24)
      }.marginBottom(20)
      
      flex.addItem(saveButton).height(52)
    }
  }
  
  private func bind() {
    staffView.rx.tapGesture
      .bind(with: self) { owner, _ in
        owner.staffLabel.textColor = Colors.Blue._4
        owner.checkImageView.image = Images.check?.withTintColor(Colors.Blue._4)
        owner.memberLabel.textColor = Colors.Gray._5
        owner.checkImageView2.image = Images.check?.withTintColor(Colors.Gray._3)
        
        owner.selectedRole = .staff
      }
      .disposed(by: disposeBag)
    
    memberView.rx.tapGesture
      .bind(with: self) { owner, _ in
        owner.staffLabel.textColor = Colors.Gray._5
        owner.checkImageView.image = Images.check?.withTintColor(Colors.Gray._3)
        owner.memberLabel.textColor = Colors.Blue._4
        owner.checkImageView2.image = Images.check?.withTintColor(Colors.Blue._4)
        
        owner.selectedRole = .member
      }
      .disposed(by: disposeBag)
  }
}

extension AssignRoleView {
  var tapSave: Observable<Member.Role> {
    return saveButton.rx.tap
      .map { _ in self.selectedRole }
  }
}
