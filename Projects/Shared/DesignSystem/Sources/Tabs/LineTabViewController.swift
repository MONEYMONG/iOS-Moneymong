import UIKit

import PinLayout
import FlexLayout

public final class LineTabViewController: UIViewController {
  private let controllers: [UIViewController]
  
  private lazy var tabView: MMLineTabs = {
    let v = MMLineTabs(items: controllers.map { $0.title as Any })
    v.selectedSegmentIndex = 0
    v.addTarget(
      self,
      action: #selector(changeTab),
      for: .valueChanged
    )
    v.backgroundColor = .clear
    return v
  }()
  
  private lazy var pageViewController: UIPageViewController = {
    let vc = UIPageViewController(
      transitionStyle: .scroll,
      navigationOrientation: .horizontal,
      options: nil
    )
    vc.setViewControllers(
      [controllers[0]],
      direction: .forward,
      animated: true
    )
    vc.delegate = self
    vc.dataSource = self
    return vc
  }()
  
  private let rootContainer = UIView()
  
  public var currentPage: Int = 0 {
    didSet {
      let direction: UIPageViewController.NavigationDirection = oldValue <= currentPage ? .forward : .reverse
      pageViewController.setViewControllers(
        [controllers[currentPage]],
        direction: direction,
        animated: true,
        completion: nil
      )
      tabView.selectedSegmentIndex = currentPage
    }
  }
  
  public init(_ controllers: [UIViewController]) {
    self.controllers = controllers
    super.init(nibName: nil, bundle: nil)
    setupView()
    setupConstraints()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin.all()
    rootContainer.flex.layout()
    
    tabView.pin.top().left().right().height(50)
    pageViewController.view.pin.left().right().bottom().below(of: tabView)

  }
  
  private func setupView() {}
  
  private func setupConstraints() {
    view.addSubview(rootContainer)
    rootContainer.addSubview(pageViewController.view)
    rootContainer.addSubview(tabView)

  }
  
  @objc
  private func changeTab() {
    currentPage = tabView.selectedSegmentIndex
  }
}

extension LineTabViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
  public func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerBefore viewController: UIViewController
  ) -> UIViewController? {
    guard
      let index = controllers.firstIndex(of: viewController),
      index - 1 >= 0
    else { return nil }
    return controllers[index - 1]
  }
  
  public func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerAfter viewController: UIViewController
  ) -> UIViewController? {
    guard
      let index = controllers.firstIndex(of: viewController),
      index + 1 < controllers.count
    else { return nil }
    return controllers[index + 1]
  }
  
  public func pageViewController(
    _ pageViewController: UIPageViewController,
    didFinishAnimating finished: Bool,
    previousViewControllers: [UIViewController],
    transitionCompleted completed: Bool
  ) {
    guard
      let viewController = pageViewController.viewControllers?[0],
      let index = controllers.firstIndex(of: viewController)
    else { return }
    currentPage = index
  }
}

