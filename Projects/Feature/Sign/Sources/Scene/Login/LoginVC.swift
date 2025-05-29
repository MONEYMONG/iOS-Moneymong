import UIKit

import DesignSystem
import BaseFeature
import ReactorKit
import Utility

final class LoginVC: BaseVC, View {
  var coordinator: SignCoordinator?
  var disposeBag = DisposeBag()
  let pages: [UIViewController] = [OnboardingVC(pageNumber: 0), OnboardingVC(pageNumber: 1), OnboardingVC(pageNumber: 2)]
  
  private let pageViewController: UIPageViewController = {
    let pageView = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

    return pageView
  }()
  
  private let pageControl: UIPageControl = {
    let pageControl = UIPageControl()
    pageControl.currentPage = 0
    pageControl.currentPageIndicatorTintColor = Colors.Blue._4
    pageControl.pageIndicatorTintColor = Colors.Gray._3
    pageControl.backgroundStyle = .minimal
    return pageControl
  }()

  private let recentProviderToolTip: ToolTip = {
    let tooltip = ToolTip(type: .bottom)
    tooltip.setTitle(with: Const.bubbleTitle)
    tooltip.setBackgroundColor(with: Colors.Blue._4)
    tooltip.setCorneradius(8)
    tooltip.setFonts(with: Fonts.body._3)
    tooltip.setTitleColor(with: .white)
    tooltip.isHidden = true
    return tooltip
  }()

  private let appleLoginButton = SocialLoginButton(type: .apple)
  private let kakaoLoginButton = SocialLoginButton(type: .kakao)

  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }

  override func setupUI() {
    super.setupUI()
    setLeftItem(.none)
    pageViewController.dataSource = self
    pageViewController.delegate = self
    pageViewController.setViewControllers(
      [pages[0]],
      direction: .forward,
      animated: true
    )
    pageControl.numberOfPages = pages.count
  }

  override func setupConstraints() {
    super.setupConstraints()

    rootContainer.flex
      .backgroundColor(Colors.Gray._1)
      .define { flex in
        flex.addItem().grow(1)
        flex.addItem()
          .direction(.column)
          .alignSelf(.center)
          .alignItems(.center)
          .marginTop(46)
          .justifyContent(.center)
          .define { flex in
            flex.addItem(pageViewController.view)
              .height(442)
              .marginBottom(20)
            flex.addItem(pageControl)
          }
        
        flex.addItem().grow(1)

        flex.addItem()
          .direction(.column)
          .paddingHorizontal(20)
          .marginBottom(46)
          .define { flex in

            flex.addItem(appleLoginButton)
              .backgroundColor(Colors.Black._1)
              .height(56)

            flex.addItem().height(12)

            flex.addItem(kakaoLoginButton)
              .backgroundColor(Colors.Yellow._1)
              .height(56)
          }
      }

    rootContainer.addSubview(recentProviderToolTip)
  }

  func bind(reactor: LoginReactor) {
    // State Binding

    reactor.pulse(\.$destination)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, destination in
        switch destination {
        case .main:
          owner.coordinator?.move(to: .main)
        case .signUp:
          owner.coordinator?.createAgency()
        }
      }
      .disposed(by: disposeBag)

    reactor.pulse(\.$recentLoginType)
      .compactMap { $0 }
      .delay(.milliseconds(10), scheduler: MainScheduler.instance)
      .bind(with: self) { owner, type in

        owner.recentProviderToolTip.isHidden = false

        switch type {
        case .apple:
          owner.recentProviderToolTip.pin
            .hCenter()
            .after(of: owner.appleLoginButton, aligned: .bottom)
            .marginBottom(63)

        case .kakao:
          owner.recentProviderToolTip.pin
            .hCenter()
            .after(of: owner.kakaoLoginButton, aligned: .bottom)
            .marginBottom(63)
        }
      }
      .disposed(by: disposeBag)

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

    // Action Binding
    rx.viewDidAppear
      .do(onNext: { [weak self] _ in
        self?.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
      })
      .map { Reactor.Action.onAppear }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    rx.viewDidDisappear
      .bind(with: self) { owner, _ in
        owner.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
      }
      .disposed(by: disposeBag)

    appleLoginButton.rx.tap
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .do { _ in FirebaseManager.shared.logEvent(event: .appleLogin) }
      .map { Reactor.Action.login(.apple) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    kakaoLoginButton.rx.tap
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .do { _ in FirebaseManager.shared.logEvent(event: .kakaoLogin) }
      .map { Reactor.Action.login(.kakao) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
}

extension LoginVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerBefore viewController: UIViewController
  ) -> UIViewController? {
    guard let index = pages.firstIndex(of: viewController as! OnboardingVC) else { return nil }
    let nextIndex = (index - 1 + pages.count) % pages.count

    return pages[nextIndex]
  }
  
  func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerAfter viewController: UIViewController
  ) -> UIViewController? {
    guard let index = pages.firstIndex(of: viewController) else { return nil }
    let nextIndex = (index + 1) % pages.count

    return pages[nextIndex]
  }
  
  func pageViewController(
    _ pageViewController: UIPageViewController,
    didFinishAnimating finished: Bool,
    previousViewControllers: [UIViewController],
    transitionCompleted completed: Bool
  ) {
    guard let viewControllers = pageViewController.viewControllers,
          let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
    
    pageControl.currentPage = currentIndex
  }
}

fileprivate enum Const {
  static var bubbleTitle: String { "마지막으로 로그인한 계정이에요" }
  static var kakaoButtonTitle: String { "카카오 로그인" }
  static var appleButtonTitle: String { "Apple로 로그인" }
}

