import UIKit
import AVFoundation

import Core

import RxSwift

final class CameraView: UIView {
  weak var delegate: AVCapturePhotoCaptureDelegate?
  
  private let captureSession: AVCaptureSession = {
    let session = AVCaptureSession()
    session.sessionPreset = .photo
    return session
  }()
  
  private let stillImageOutput = AVCapturePhotoOutput()
  
  private let videoPreviewLayer: AVCaptureVideoPreviewLayer = {
    let layer = AVCaptureVideoPreviewLayer()
    layer.videoGravity = .resizeAspectFill
    return layer
  }()
  
  init() {
    super.init(frame: .zero)
    setupUI()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    layer.addSublayer(videoPreviewLayer)
  }
  
  func setupCameraFrame(frame: CGRect) {
    videoPreviewLayer.frame = frame
    setNeedsLayout()
  }
  
  func setupCamera() throws {
    let deviceTypes: [AVCaptureDevice.DeviceType] = [
      .builtInTripleCamera,  // 최신 프로 모델의 트리플 카메라
      .builtInDualCamera,    // 듀얼 카메라 (프로 및 일부 비프로 모델)
      .builtInWideAngleCamera // 광각 카메라 (단일 렌즈 카메라)
    ]
    
    // 사용 가능한 장치 중 후면 카메라와 일치하는 장치를 찾기
    guard let backCamera = AVCaptureDevice.DiscoverySession(
      deviceTypes: deviceTypes,
      mediaType: .video,
      position: .back
    ).devices.first,
          let input = try? AVCaptureDeviceInput(device: backCamera) else {
      throw MoneyMongError.appError(.cameraAccess, errorMessage: "설정에서 카메라 접근을 허용해주세요!")
    }
    
    // 세션에 입력 추가
    if captureSession.canAddInput(input) {
      captureSession.addInput(input)
    } else {
      throw MoneyMongError.appError(.cameraAccess, errorMessage: "입력을 세션에 추가할 수 없습니다.")
    }
    
    // 사진 출력 설정
    if captureSession.canAddOutput(stillImageOutput) {
      captureSession.addOutput(stillImageOutput)
    }
    
    // 프리뷰 레이어 설정
    videoPreviewLayer.session = captureSession
    
    // 자동 초점 조절
    try configureCameraFocus(backCamera)
    
    // 세션 시작
    DispatchQueue.main.async {
      self.captureSession.startRunning()
    }
  }
  
  private func configureCameraFocus(_ camera: AVCaptureDevice) throws {
    try camera.lockForConfiguration()
    
    // 연속 자동 초점 모드 설정
    if camera.isFocusModeSupported(.continuousAutoFocus) {
      camera.focusMode = .continuousAutoFocus
    }
    
    // 연속 자동 노출 모드 설정
    if camera.isExposureModeSupported(.continuousAutoExposure) {
      camera.exposureMode = .continuousAutoExposure
    }
    
    camera.unlockForConfiguration()
  }
  
  var takePhoto: Binder<Void> {
    return Binder(self) { owner, _ in
      guard let delegate = owner.delegate else {
        fatalError("델리게이트를 설정하세요.")
      }
      let settings = AVCapturePhotoSettings()
      owner.stillImageOutput.capturePhoto(with: settings, delegate: delegate)
    }
  }
}



