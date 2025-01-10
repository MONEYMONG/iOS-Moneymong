import UIKit
import AVFoundation

import Core

import RxSwift

protocol CameraViewDelegate: AnyObject {
  func cameraView(_ cameraView: CameraView, scanResult result: UIImage, originalImage image: UIImage)
}

final class CameraView: UIView {
  weak var delegate: CameraViewDelegate?
  
  private var scanFailedCount = 0 {
    didSet {
      if scanFailedCount > 10, !maskLayer.isHidden {
        maskLayer.isHidden = true
        scanFailedCount = 0
      }
    }
  }
  
  private let captureSession: AVCaptureSession = {
    let session = AVCaptureSession()
    session.sessionPreset = .photo
    return session
  }()
  
  private let stillImageOutput = AVCapturePhotoOutput()
  private let videoDataOutput = AVCaptureVideoDataOutput()
  private let documentScanner = DocumentScanner()
  
  private var maskLayer = CAShapeLayer()
  
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
    
    if captureSession.canAddOutput(videoDataOutput) {
      self.videoDataOutput.setSampleBufferDelegate(self, queue: .global())
      captureSession.addOutput(videoDataOutput)
      
      guard let connection = self.videoDataOutput.connection(with: AVMediaType.video),
            connection.isVideoOrientationSupported else { return }
      
      connection.videoOrientation = .portrait
    }
    
    self.layer.addSublayer(maskLayer)
    
    // 프리뷰 레이어 설정
    videoPreviewLayer.session = captureSession
    
    // 자동 초점 조절
    try configureCameraFocus(backCamera)
    
    // 세션 시작
    DispatchQueue.global().async {
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
      let settings = AVCapturePhotoSettings()
      owner.stillImageOutput.capturePhoto(with: settings, delegate: owner)
    }
  }
}

extension CameraView: AVCaptureVideoDataOutputSampleBufferDelegate {
  func captureOutput(_ output: AVCaptureOutput,didOutput sampleBuffer: CMSampleBuffer,from connection: AVCaptureConnection) {
    guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

    Task {
      guard let scanRect = try await documentScanner.scanDocument(previewSize: self.bounds, pixelBuffer: buffer) else {
        scanFailedCount += 1
        return
      }
      scanFailedCount = 0
      updateMaskLayer(in: scanRect)
    }
  }
  
  private func updateMaskLayer(in rect: CGRect) {
    maskLayer.isHidden = false
    maskLayer.frame = rect
    maskLayer.cornerRadius = 10
    maskLayer.borderColor = UIColor.systemBlue.cgColor
    maskLayer.borderWidth = 1
    maskLayer.opacity = 1
  }
}

extension CameraView: AVCapturePhotoCaptureDelegate {
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    Task {
      guard let imageData = photo.fileDataRepresentation(),
            let originalImage = UIImage(data: imageData),
            let result = await documentScanner.editImageWithScanResult(imageData) else { return }
      
      delegate?.cameraView(self, scanResult: UIImage(cgImage: result), originalImage: originalImage)
    }
  }
}
