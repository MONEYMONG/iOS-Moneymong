import UIKit
import AVFoundation

import DesignSystem

import FlexLayout
import PinLayout

final class ScanInputVC: UIViewController {
  private let rootContainer = UIView()
  
  private let cameraView = CameraView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupConstraints()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin.all()
    rootContainer.flex.layout()
  }

  private func setupUI() {
    cameraView.delegate = self
  }
  
  private func setupConstraints() {
    view.addSubview(rootContainer)
  }
}

extension ScanInputVC: AVCapturePhotoCaptureDelegate {
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    // 사진 캡처 후 처리
    guard let imageData = photo.fileDataRepresentation() else { return }
    let image = UIImage(data: imageData)
    // 이제 UIImage 객체를 사용할 수 있습니다.
  }
}
