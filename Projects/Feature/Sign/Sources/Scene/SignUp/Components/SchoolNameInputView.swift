import UIKit

import PinLayout
import FlexLayout
import DesignSystem

final class SchoolNameInputView: UIView {
  private let rootContainer = UIView()

  private let searchBar: MMSearchBar = {
    let searchBar = MMSearchBar(title: Const.university, didSearch: nil)
    searchBar.setPlaceholder(to: Const.searchBarPlaceholder)
    return searchBar
  }()

  private let tableView: UITableView = {
    let tableView = UITableView()
    return tableView
  }()

  init() {
    super.init(frame: .zero)
    setupView()
    setupConstraints()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }

  private func setupView() {
    addSubview(rootContainer)
  }

  private func setupConstraints() {
    rootContainer.flex.define { flex in
      flex.addItem(searchBar)
      flex.addItem().height(4)
      flex.addItem(tableView)
    }
  }
}

private enum Const {
  static var university: String { "대학교" }
  static var searchBarPlaceholder: String { "ex)머니대학교" }
}
