import UIKit

import DesignSystem

final class NavigationVC: UIViewController {
  
  private let rootContainer = UIView()

  private let leftSegment: UISegmentedControl = {
    let v = UISegmentedControl(items: ["back", "close1", "close2", "trash", "수정완료"])
    v.selectedSegmentIndex = 0
    return v
  }()
  
  private let rightSegment: UISegmentedControl = {
    let v = UISegmentedControl(items: ["back", "close1", "close2", "trash", "수정완료"])
    v.selectedSegmentIndex = 4
    return v
  }()
  
  private func barItem(_ index: Int) -> BarItem {
    switch index {
    case 0: return .back
    case 1: return .closeBlack
    case 2: return .closeWhite
    case 3: return .trash
    case 4: return .수정완료
    default: fatalError()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    setupConstriants()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }
  
  private func setupView() {
    view.backgroundColor = .systemGray5
    
    setTitle("타이틀")
    setLeftItem(.back)
    setRightItem(.수정완료)
    
    ["back", "close1", "close2", "trash", "수정완료"].enumerated().forEach { (index, title) in
      leftSegment.setAction(.init(title: title) { [self] _ in
        setLeftItem(barItem(index))
      }, forSegmentAt: index)
      
      rightSegment.setAction(.init(title: title) { [self] _ in
        setRightItem(barItem(index))
      }, forSegmentAt: index)
    }
  }
  
  private func setupConstriants() {
    view.addSubview(rootContainer)
    
    rootContainer.flex.justifyContent(.center).padding(5).define { flex in
      flex.addItem(leftSegment)
        .marginBottom(20)
      flex.addItem(rightSegment)
    }
  }
}

#if DEBUG
import SwiftUI

struct MyViewPreview: PreviewProvider{
  static var previews: some View {
    UIViewControllerPreView {
      UINavigationController(rootViewController: NavigationVC())
    }
  }
}
#endif
