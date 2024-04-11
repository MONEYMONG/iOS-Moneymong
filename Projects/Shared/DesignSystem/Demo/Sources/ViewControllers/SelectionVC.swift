import UIKit

import DesignSystem

final class SelectionVC: UIViewController {
  
  private let label: UILabel = {
    let v = UILabel()
    v.text = "selectedIndex를 바인딩"
    v.font = .systemFont(ofSize: 24, weight: .bold)
    v.textColor = .black
    v.textAlignment = .center
    return v
  }()
  private let selectionView1 = MMSegmentControl(titles: ["지출", "수입"], type: .round)
  private let selectionView2 = MMSegmentControl(titles: ["전체", "지출", "수입"], type: .capsule)
  private let selectionView3 = MMSegmentControl(titles: ["1학년", "2학년", "3학년", "4학년", "5학년"], type: .round)
  private let rootContainer = UIView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupConstraints()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    rootContainer.pin.vertically().horizontally(20)
    rootContainer.flex.layout()
  }
  
  private func setupView() {
    view.backgroundColor = .white
    title = "Tags"
    
    selectionView1.selectedIndex = 0
    selectionView2.selectedIndex = 0
  }
  
  private func setupConstraints() {
    view.addSubview(rootContainer)
    rootContainer.flex.justifyContent(.center).define { flex in
      flex.addItem(label).marginBottom(30)
      flex.addItem(selectionView1).marginBottom(30)
      flex.addItem(selectionView2).marginBottom(30)
      flex.addItem(selectionView3)
    }
  }
}
