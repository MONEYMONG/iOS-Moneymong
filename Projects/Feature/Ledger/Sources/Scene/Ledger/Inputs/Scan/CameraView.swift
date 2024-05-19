import UIKit
import AVFoundation

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
    layer.frame = UIScreen.main.bounds
    return layer
  }()
  
  init() {
    super.init(frame: .zero)
    setupUI()
    settingCamera()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    layer.addSublayer(videoPreviewLayer)
  }
  
  private func settingCamera() {
    // 사용 가능한 카메라 중 후면 카메라를 선택
    guard let backCamera = AVCaptureDevice.default(for: .video),
          let input = try? AVCaptureDeviceInput(device: backCamera) else {
      print("후면 카메라를 사용할 수 없습니다.")
      return
    }
    
    // 세션에 입력 추가
    if captureSession.canAddInput(input) {
      captureSession.addInput(input)
    } else {
      print("입력을 세션에 추가할 수 없습니다.")
      return
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
  
  // 사진 캡처 함수
  func takePhoto() {
    guard let delegate else {
      fatalError("델리게이트를 설정하세요.")
    }
    let settings = AVCapturePhotoSettings()
    stillImageOutput.capturePhoto(with: settings, delegate: delegate)
  }
}



