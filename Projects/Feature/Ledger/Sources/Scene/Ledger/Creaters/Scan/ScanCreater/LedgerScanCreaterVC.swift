import UIKit
import AVFoundation

import DesignSystem

import FlexLayout
import PinLayout
import ReactorKit

final class LedgerScanCreaterVC: UIViewController, View {
  var disposeBag = DisposeBag()
  
  weak var coordinator: LedgerScanCreaterCoordinator?
  
  private let rootContainer = UIView()
  
  private let cameraView = CameraView()
  
  private let bottomContainer: UIView = {
    let v = UIView()
    v.backgroundColor = .black.withAlphaComponent(0.6)
    return v
  }()
  
  private let cameraShutterButton: UIButton = {
    let v = UIButton()
    v.setImage(Images.cameraShutter, for: .normal)
    return v
  }()
  
  private let tapGuideLine: UIView = {
    let v = UIView()
    v.layer.cornerRadius = 2
    v.backgroundColor = Colors.Mint._3
    return v
  }()
  
  private let bottomGuideLine: UIView = {
    let v = UIView()
    v.layer.cornerRadius = 2
    v.backgroundColor = Colors.Mint._3
    return v
  }()
  
  private let guideLabel: UILabel = {
    let v = UILabel()
    v.font = Fonts.heading._1
    v.numberOfLines = 2
    v.setTextWithLineHeight(text: "영수증의 처음과 끝이\n모두 포함되게 촬용해주세요", lineHeight: 28)
    v.setShadow(location: .center)
    v.textColor = .white
    v.textAlignment = .center
    return v
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupConstraints()
    coordinator?.present(.guide, animated: false)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    cameraView.pin.all()
    rootContainer.pin.horizontally().bottom().top(view.pin.safeArea.top)
    rootContainer.flex.layout()
    
    let guideLineWidth: Int = Int(UIScreen.main.bounds.width - 40)
    let guideLineXPosition: Int = (Int(UIScreen.main.bounds.width) - guideLineWidth) / 2
    
    tapGuideLine.frame = CGRect(
      x: guideLineXPosition,
      y: Int(navigationController!.navigationBar.frame.height) - 2,
      width: guideLineWidth,
      height: 4
    )
    
    bottomGuideLine.frame = CGRect(
      x: guideLineXPosition,
      y: -2,
      width: guideLineWidth,
      height: 4
    )
  }

  private func setupUI() {
    cameraView.delegate = self
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .black.withAlphaComponent(0.6)
    appearance.backgroundEffect = nil
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    navigationController?.navigationBar.standardAppearance = appearance
  }
  
  private func setupConstraints() {
    view.addSubview(cameraView)
    view.addSubview(rootContainer)
    
    rootContainer.flex.define { flex in
      flex.addItem().grow(1).define { flex in
        flex.addItem(guideLabel)
      }.alignItems(.center).justifyContent(.center)
      flex.addItem(bottomContainer).define { flex in
        flex.addItem(cameraShutterButton)
      }.alignItems(.center).justifyContent(.center)
      .height(142)
    }
    navigationController?.navigationBar.addSubview(tapGuideLine)
    bottomContainer.addSubview(bottomGuideLine)
  }
  
  func bind(reactor: LedgerScanCreaterReactor) {
    setLeftItem(.warning)
    setRightItem(.closeWhite)
    
    navigationItem.leftBarButtonItem?.rx.tap
      .bind(with: self) { owner, _ in
        owner.coordinator?.present(.guide, animated: false)
      }
      .disposed(by: disposeBag)
    
    navigationItem.rightBarButtonItem?.rx.tap
      .bind(with: self) { owner, _ in
        owner.coordinator?.dismiss(animated: true)
      }
      .disposed(by: disposeBag)
  }
}

extension LedgerScanCreaterVC: AVCapturePhotoCaptureDelegate {
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    // 사진 캡처 후 처리
    guard let imageData = photo.fileDataRepresentation() else { return }
    let image = UIImage(data: imageData)
    // 이제 UIImage 객체를 사용할 수 있습니다.
  }
}
