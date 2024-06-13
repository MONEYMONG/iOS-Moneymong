import UIKit
import AVFoundation

import DesignSystem
import NetworkService

import FlexLayout
import PinLayout
import ReactorKit

final class CreateOCRLedgerVC: UIViewController, View {
  var disposeBag = DisposeBag()
  
  weak var coordinator: CreateOCRLedgerCoordinator?
  
  private let deviceHeight = UIScreen.main.bounds.height
  
  private let rootContainer = UIView()
  
  private let cameraView = CameraView()
  
  private let bottomContainer: UIView = {
    let v = UIView()
    v.backgroundColor = .black
    return v
  }()
  
  private let topContainer: UIView = {
    let v = UIView()
    v.backgroundColor = .black
    return v
  }()
  
  private let cameraShutterButton: UIButton = {
    let v = UIButton()
    v.setImage(Images.cameraShutter, for: .normal)
    return v
  }()
  
  private let topGuideLine: UIView = {
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
    v.setTextWithLineHeight(text: "영수증의 처음과 끝이\n모두 포함되게 촬영해주세요", lineHeight: 28)
    v.setShadow(location: .center)
    v.textColor = .white
    v.textAlignment = .center
    return v
  }()
  
  private let captureImageView: UIImageView = {
    let v = UIImageView()
    v.contentMode = .scaleAspectFill
    v.clipsToBounds = true
    v.isHidden = true
    return v
  }()
  
  private let indicatorContainer: UIView = {
    let v = UIView()
    v.backgroundColor = .black.withAlphaComponent(0.7)
    v.isHidden = true
    return v
  }()
  
  private let indicator = MMIndicator()
  
  deinit {
    coordinator?.remove()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupConstraints()
    coordinator?.present(.guide, animated: false)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    topContainer.frame = .init(
      x: 0,
      y: 0,
      width: UIScreen.main.bounds.width,
      height: view.safeAreaInsets.top
    )
    rootContainer.pin.horizontally().bottom().below(of: topContainer)
    rootContainer.flex.layout()
    indicatorContainer.frame = view.frame
    indicatorContainer.flex.layout()
    
    let guideLineWidth: Int = Int(UIScreen.main.bounds.width - 40)
    let guideLineXPosition: Int = (Int(UIScreen.main.bounds.width) - guideLineWidth) / 2
    
    topGuideLine.frame = CGRect(
      x: guideLineXPosition,
      y: Int(topContainer.frame.height) - 2,
      width: guideLineWidth,
      height: 4
    )
    
    bottomGuideLine.frame = CGRect(
      x: guideLineXPosition,
      y: -2,
      width: guideLineWidth,
      height: 4
    )
    cameraView.setupCameraFrame(frame: cameraView.frame)
    captureImageView.pin.all()
  }

  private func setupUI() {
    do {
      cameraView.delegate = self
      try cameraView.setupCamera()
    } catch {
      reactor?.action.onNext(.onError(error as! MoneyMongError))
    }
  }
  
  private func setupConstraints() {
    view.addSubview(rootContainer)
    
    rootContainer.flex.define { flex in
      flex.addItem(cameraView).grow(1).define { flex in
        flex.addItem(guideLabel)
      }.alignItems(.center).justifyContent(.center)
      flex.addItem(bottomContainer).define { flex in
        flex.addItem(cameraShutterButton)
          .size(deviceHeight * 0.074)
      }
      .alignItems(.center)
      .justifyContent(.center)
      .height(deviceHeight * 0.175)
    }
    cameraView.addSubview(captureImageView)
    view.addSubview(topContainer)
    topContainer.addSubview(topGuideLine)
    bottomContainer.addSubview(bottomGuideLine)
    navigationController?.view.addSubview(indicatorContainer)
    indicatorContainer.flex.justifyContent(.center).alignItems(.center).define { flex in
      flex.addItem(indicator)
    }
  }
  
  func bind(reactor: CreateOCRLedgerReactor) {
    setLeftItem(.warning)
    setRightItem(.closeWhite)
    
    navigationItem.leftBarButtonItem?.rx.tap
      .bind(with: self) { owner, _ in
        owner.coordinator?.present(.guide, animated: false)
      }
      .disposed(by: disposeBag)
    
    navigationItem.rightBarButtonItem?.rx.tap
      .bind(with: self) { owner, _ in
        owner.dismiss(animated: true)
      }
      .disposed(by: disposeBag)
    
    cameraShutterButton.rx.tap
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .bind(to: cameraView.takePhoto)
      .disposed(by: disposeBag)
    
    rx.viewWillAppear
      .map { Reactor.Action.onAppear }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$imageData)
      .map { $0 != nil ? UIImage(data: $0!) : nil }
      .bind(to: captureImageView.rx.image)
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$imageData)
      .map { $0 == nil }
      .bind(with: self) { owner, value in
        owner.captureImageView.isHidden = value
        owner.guideLabel.isHidden = !value
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$isLoading)
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, value in
        owner.indicatorContainer.isHidden = !value
        if value {
          owner.indicator.startAnimating()
        } else {
          owner.indicator.stopAnimating()
        }
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$error)
      .compactMap { $0?.errorDescription }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, message in
        var title: String? = nil
        if message == "설정에서 카메라 접근을 허용해주세요!" {
          title = "현재 머니몽이\n카메라에 접근할 수 없어요"
        }
        owner.coordinator?.present(
          .alert(
            title: title ?? "오류",
            subTitle: message,
            type: .onlyOkButton()
          )
        )
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$destination)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { owner, destination in
        switch destination {
        case let .scanResult(id, model, data):
          owner.coordinator?.present(.scanResult(id, model: model, imageData: data))
        }
      }
      .disposed(by: disposeBag)
  }
}

extension CreateOCRLedgerVC: AVCapturePhotoCaptureDelegate {
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    let imageData = photo.fileDataRepresentation()
    reactor?.action.onNext(.receiptShoot(imageData))
  }
}
