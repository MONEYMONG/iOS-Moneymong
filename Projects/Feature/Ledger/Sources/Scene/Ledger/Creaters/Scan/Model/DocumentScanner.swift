import Vision
import CoreImage

actor DocumentScanner: Sendable {
  private var recentScanResult: VNRectangleObservation?
  
  func scanDocument(imageBuffer: CVImageBuffer, with previewSize: CGRect) async throws -> CGRect? {
    return try await withCheckedThrowingContinuation { [weak self] continuation in
      guard let self else { continuation.resume(returning: nil); return }
      let request = VNDetectRectanglesRequest { (request: VNRequest, error: Error?) in
        guard let results = request.results as? [VNRectangleObservation],
              let rectangleObservation = results.first else {
          continuation.resume(returning: nil); return
        }
        
        Task {
          await self.updateRecentScanResult(rectangleObservation)
          let rect = await self.transformVisionToIOS(rectangleObservation, to: previewSize)
          continuation.resume(returning: rect)
        }
      }
      
      request.minimumAspectRatio = 0.2
      request.maximumAspectRatio = 1.0
      request.minimumConfidence = 0.8
      
      let handler = VNImageRequestHandler(cvPixelBuffer: imageBuffer, options: [:])
      do {
        try handler.perform([request])
      } catch {
        continuation.resume(throwing: error)
      }
    }
  }
  
  func editImageWithScanResult(_ imageData: Data) -> CIImage? {
    guard let ciImage = CIImage(data: imageData)?.oriented(.right),
          let recentScanResult else { return nil }
    
    let topLeft = recentScanResult.topLeft.scaled(to: ciImage.extent.size)
    let topRight = recentScanResult.topRight.scaled(to: ciImage.extent.size)
    let bottomLeft = recentScanResult.bottomLeft.scaled(to: ciImage.extent.size)
    let bottomRight = recentScanResult.bottomRight.scaled(to: ciImage.extent.size)

    return ciImage.applyingFilter("CIPerspectiveCorrection", parameters: [
      "inputTopLeft": CIVector(cgPoint: topLeft),
      "inputTopRight": CIVector(cgPoint: topRight),
      "inputBottomLeft": CIVector(cgPoint: bottomLeft),
      "inputBottomRight": CIVector(cgPoint: bottomRight),
    ])
  }
  
  private func transformVisionToIOS(_ rectangleObservation: VNRectangleObservation, to previewSize: CGRect) -> CGRect {
    let visionRect = rectangleObservation.boundingBox
    return CGRect(
      origin: CGPoint(x: CGFloat(visionRect.minX * previewSize.width), y: CGFloat((1 - visionRect.maxY) * previewSize.height)),
      size: CGSize(width: visionRect.width * previewSize.width, height: visionRect.height * previewSize.height)
    )
  }
  
  private func updateRecentScanResult(_ rectangleObservation: VNRectangleObservation) {
    recentScanResult = rectangleObservation
  }
}

private extension CGPoint {
  func scaled(to size: CGSize) -> CGPoint {
    return CGPoint(x: self.x * size.width,
                   y: self.y * size.height)
  }
}

extension CVImageBuffer: @unchecked @retroactive Sendable {}

