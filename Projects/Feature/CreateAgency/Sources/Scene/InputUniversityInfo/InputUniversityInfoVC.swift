import UIKit
import Combine

import DesignSystem
import BaseFeature
import Core
import CreateAgencyInterface
import UserInterface

import FlexLayout
import PinLayout
import ReactorKit

final class InputUniversityInfoVC: UIViewController, View {
  var disposeBag = DisposeBag()
  private var anyCancellable = Set<AnyCancellable>()
  
  private let completeFactory: CreateCompleteFactoryInterface
  
  var coordinator: CreateAgencyCoordinator?
  
  private var keybordShowCreateButtonConstraints: [NSLayoutConstraint] = []
  private var keybordHideCreateButtonConstraints: [NSLayoutConstraint] = []
  
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
    tableView.contentInset.bottom = 28
    return tableView
  }()
  
  private let registerButton: MMButton = {
    let button = MMButton(title: Const.confirmTitle, type: .disable)
    return button
  }()
  
  private let notRegisterButton: UIButton = {
    let button = UIButton()
    button.setTitle(Const.notRegisterButton, for: .normal)
    button.setTitleColor(Colors.Blue._4, for: .normal)
    button.titleLabel?.font = Fonts.body._3
    return button
  }()
    
  init(completeFactory: CreateCompleteFactoryInterface) {
    self.completeFactory = completeFactory
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupConstraints()
    setupUI()
  }
  
  func setupUI() {
    view.backgroundColor = .white
    navigationItem.hidesBackButton = true
    tableView.backgroundView = emptyListView
  }
  
  func setupConstraints() {
    view.addSubview(titleLabel)
    view.addSubview(descriptionLabel)
    view.addSubview(searchBar)
    view.addSubview(tableView)
    view.addSubview(registerButton)
    view.addSubview(notRegisterButton)
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    tableView.translatesAutoresizingMaskIntoConstraints = false
    registerButton.translatesAutoresizingMaskIntoConstraints = false
    notRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
      titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
    ])
    
    NSLayoutConstraint.activate([
      descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
      descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
    ])
    
    NSLayoutConstraint.activate([
      searchBar.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
      searchBar.heightAnchor.constraint(equalToConstant: 56),
      searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
    ])
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 4),
      tableView.bottomAnchor.constraint(equalTo: registerButton.topAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
    ])
    
    keybordHideCreateButtonConstraints = [
      registerButton.heightAnchor.constraint(equalToConstant: 56),
      registerButton.bottomAnchor.constraint(equalTo: notRegisterButton.topAnchor, constant: -16),
      registerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
      registerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12)
    ]
    
    keybordShowCreateButtonConstraints = [
      registerButton.heightAnchor.constraint(equalToConstant: 56),
      registerButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
      registerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 3),
      registerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: -3)
    ]
    
    NSLayoutConstraint.activate(keybordHideCreateButtonConstraints)
    
    NSLayoutConstraint.activate([
      notRegisterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      notRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }
  
  func bind(reactor: InputUniversityInfoReactor) {
    // State Binding
    
    reactor.pulse(\.$errorMessage)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, errorMessage in
        AlertsManager.show(title: errorMessage, type: .onlyOkButton())
      }
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
    
    reactor.pulse(\.$isConfirm)
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, value in
        owner.registerButton.setState(value ? .primary : .disable)
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$destination)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, destination in
        switch destination {
        case .main:
          owner.dismiss(animated: true)
          owner.coordinator?.move(to: .main)
        case let .complete(id):
          let vc = owner.completeFactory.make(coordinator: owner.coordinator, id: id)
          owner.navigationController?.pushViewController(vc, animated: true)
        }
      }
      .disposed(by: disposeBag)
    
    // Action Binding
    
    setLeftItem(.back)
    
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
      .bind(with: self) { owner, _ in
        UIView.animate(withDuration: 0.2) {
          NSLayoutConstraint.deactivate(owner.keybordHideCreateButtonConstraints)
          NSLayoutConstraint.activate(owner.keybordShowCreateButtonConstraints)
        }
        
        UIView.animate(withDuration: 0.2) {
          owner.registerButton.layer.cornerRadius = 0
        }
        owner.view.layoutIfNeeded()
      }
      .disposed(by: disposeBag)
    
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
      .bind(with: self) { owner, _ in
        UIView.animate(withDuration: 0.2) {
          NSLayoutConstraint.deactivate(owner.keybordShowCreateButtonConstraints)
          NSLayoutConstraint.activate(owner.keybordHideCreateButtonConstraints)
        }
        
        UIView.animate(withDuration: 0.2) {
          owner.registerButton.layer.cornerRadius = 12
        }
        owner.view.layoutIfNeeded()
      }
      .disposed(by: disposeBag)
    
    navigationItem.leftBarButtonItem?.rx.tap
      .bind(with: self) { owner, _ in
        owner.navigationController?.popViewController(animated: true)
      }
      .disposed(by: disposeBag)
    
    view.rx.tapGesture
      .bind { $0.endEditing(true) }
      .disposed(by: disposeBag)
    
    searchBar.textField.rx.text
      .orEmpty
      .distinctUntilChanged()
      .debounce(.milliseconds(1500), scheduler: MainScheduler.instance)
      .map { Reactor.Action.searchKeyword($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    tableView.rx.modelSelected(University.self)
    .bind(with: self) { owner, item in
      reactor.action.onNext(.selectUniversity(item))
    }
    .disposed(by: disposeBag)

    registerButton.rx.tap
      .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
      .map { Reactor.Action.confirm }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    notRegisterButton.rx.tap
      .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
      .map { Reactor.Action.notRegisterButtonDidTap }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
}

fileprivate enum Const {
  static var title: String { "어디 학교 교내 동아리인가요?" }
  static var description: String { "소속 대학교를 알려주세요" }
  static var confirmTitle: String { "등록하기" }
  static var university: String { "대학교" }
  static var searchBarPlaceholder: String { "ex)머니대학교" }
  static var notRegisterButton: String { "총무에게 초대받았어요" }
}
