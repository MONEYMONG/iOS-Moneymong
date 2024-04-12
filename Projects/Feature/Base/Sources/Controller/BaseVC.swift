import UIKit

import RxSwift
import RxCocoa

/// BaseViewController
public class BaseVC: UIViewController {
  
  public init() {
      super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    setupConstraints()
  }
  
  public func setupUI() {
    view.backgroundColor = .white
  }
  
  public func setupConstraints() {
    
  }
}
