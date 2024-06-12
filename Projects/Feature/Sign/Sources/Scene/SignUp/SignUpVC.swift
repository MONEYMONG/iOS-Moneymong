import UIKit
import Combine

import DesignSystem
import BaseFeature
import NetworkService

import ReactorKit

final class SignUpVC: BaseVC, View {

  weak var coordinator: SignCoordinator?
  var disposeBag = DisposeBag()
  private var anyCancellable = Set<AnyCancellable>()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = Const.title
    label.font = Fonts.heading._2
    label.textColor = Colors.Black._1
    return label
  }()

  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.text = Const.description
    label.font = Fonts.body._3
    label.textColor = Colors.Gray._6
    return label
  }()

  private let searchBar: MMSearchBar = {
    let searchBar = MMSearchBar(title: Const.university, didSearch: nil)
    searchBar.setPlaceholder(to: Const.searchBarPlaceholder)
    return searchBar
  }()

  private let emptyListView: EmptyListView = {
    let view = EmptyListView()
    view.isHidden = true
    return view
  }()

  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(UniversityCell.self)
    tableView.keyboardDismissMode = .interactive
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    return tableView
  }()

  private let gradeInputView: GradeInputView = {
    let view = GradeInputView()
//    view.isHidden = true
    return view
  }()

  private let confirmButton: MMButton = {
    let button = MMButton(title: Const.confirmTitle, type: .disable)
    return button
  }()

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  override func setupUI() {
    super.setupUI()
    
    tableView.backgroundView = emptyListView
  }
  
  private let searchContentView = UIView()

  override func setupConstraints() {
    super.setupConstraints()
    rootContainer.flex
      .backgroundColor(Colors.White._1)
      .paddingHorizontal(20)
      .define { flex in
        flex.addItem().height(12)
        flex.addItem(titleLabel).marginBottom(8)
        flex.addItem(descriptionLabel).marginBottom(40)
        
        flex.addItem(searchContentView).grow(1).define { flex in
          flex.addItem(searchBar).marginBottom(4)
          flex.addItem(tableView).grow(1)
        }
        
        flex.addItem(gradeInputView).grow(1)
        flex.addItem(confirmButton).height(56).marginVertical(12)
      }
  }

  func bind(reactor: SignUpReactor) {
    // State Binding
    
    reactor.pulse(\.$errorMessage)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, errorMessage in
        owner.coordinator?.alert(title: errorMessage)
      }
      .disposed(by: disposeBag)

    reactor.pulse(\.$isLoading)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(to: rx.isLoading)
      .disposed(by: disposeBag)

    reactor.pulse(\.$schoolList)
      .compactMap { $0 }
      .bind(to: tableView.rx.items (
        cellIdentifier: UniversityCell.reuseIdentifier,
        cellType: UniversityCell.self
      )) { row, item, cell in
        cell.configure(with: item)
      }
      .disposed(by: disposeBag)

    reactor.pulse(\.$isEmptyList)
      .compactMap { $0 }.map { !$0 }
      .observe(on: MainScheduler.instance)
      .bind(to: emptyListView.rx.isHidden)
      .disposed(by: disposeBag)

    reactor.pulse(\.$inputType)
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, inputType in
        switch inputType {
        case .university:
          owner.setUniversityInput()
        case .grade(let university):
          owner.setGradeInput(to: university)
        }
      }
      .disposed(by: disposeBag)

    reactor.pulse(\.$isConfirm)
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, value in
        owner.confirmButton.setState(value ? .primary : .disable)
      }
      .disposed(by: disposeBag)

    reactor.pulse(\.$destination)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, destination in
        switch destination {
        case .congratulations:
          owner.coordinator?.congratulations()
        }
      }
      .disposed(by: disposeBag)

    // Action Binding

    setLeftItem(.back)
    
    navigationItem.leftBarButtonItem?.rx.tap
      .bind(with: self) { owner, _ in
        owner.coordinator?.pop()
      }
      .disposed(by: disposeBag)

    searchBar.textField.rx.text
      .orEmpty
      .distinctUntilChanged()
      .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
      .map { Reactor.Action.searchKeyword($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    Observable.zip(
      tableView.rx.modelSelected(University.self),
      tableView.rx.itemSelected
    )
    .delay(.milliseconds(500), scheduler: MainScheduler.instance)
    .bind(with: self) { owner, event in
      let (item, indexPath) = (event.0, event.1)
      owner.tableView.deselectRow(at: indexPath, animated: true)
      owner.searchBar.textField.resignFirstResponder()
      reactor.action.onNext(.selectUniversity(item))
    }
    .disposed(by: disposeBag)

    gradeInputView.didTapUnSelectButton
      .bind(with: self) { owner, _ in
        owner.setUniversityInput()
      }
      .disposed(by: disposeBag)

    gradeInputView.didTapSelectGrade
      .compactMap { $0 }
      .sink {
        reactor.action.onNext(.selectGrade($0+1))
      }
      .store(in: &anyCancellable)

    confirmButton.rx.tap
      .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
      .map { Reactor.Action.confirm }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  private func setGradeInput(to university: University) {
    searchContentView.flex.isIncludedInLayout(false).markDirty()
    searchContentView.isHidden = true
    
    gradeInputView.configure(university: university)
    gradeInputView.flex.isIncludedInLayout(true).markDirty()
    gradeInputView.isHidden = false
    view.setNeedsLayout()
  }

  private func setUniversityInput() {
    searchContentView.flex.isIncludedInLayout(true).markDirty()
    searchContentView.isHidden = false
    gradeInputView.flex.isIncludedInLayout(false).markDirty()
    gradeInputView.isHidden = true
    view.setNeedsLayout()
  }
}

fileprivate enum Const {
  static var title: String { "회원가입을 진행해주세요" }
  static var description: String { "아래 항목들을 정확히 채워주세요." }
  static var confirmTitle: String { "가입하기" }
  static var university: String { "대학교" }
  static var searchBarPlaceholder: String { "ex)머니대학교" }
}
