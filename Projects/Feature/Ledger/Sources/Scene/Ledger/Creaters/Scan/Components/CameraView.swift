import UIKit
import AVFoundation

import NetworkService

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
    // 사용 가능한 카메라 중 후면 카메라를 선택
    guard let backCamera = AVCaptureDevice.default(for: .video),
          let input = try? AVCaptureDeviceInput(device: backCamera) else {
      throw MoneyMongError.appError(errorMessage: "설정에서 카메라 접근을 허용해주세요!")
    }
    
    // 세션에 입력 추가
    if captureSession.canAddInput(input) {
      captureSession.addInput(input)
    } else {
      throw MoneyMongError.appError(errorMessage: "입력을 세션에 추가할 수 없습니다.")
    }
    
    // 사진 출력 설정
    if captureSession.canAddOutput(stillImageOutput) {
      captureSession.addOutput(stillImageOutput)
    }
    
    // 프리뷰 레이어 설정
    videoPreviewLayer.session = captureSession
    
    // 세션 시작
    captureSession.startRunning()
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



