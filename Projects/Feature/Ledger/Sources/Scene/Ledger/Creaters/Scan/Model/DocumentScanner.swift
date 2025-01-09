import Vision
import CoreImage

actor DocumentScanner: Sendable {
  private var recentScanResult: VNRectangleObservation?
  
  func scanDocument(previewSize: CGRect, pixelBuffer: CVPixelBuffer) async throws -> CGRect? {
    return try await withCheckedThrowingContinuation { [weak self] continuation in
      guard let self else { continuation.resume(returning: nil); return }
      let request = VNDetectRectanglesRequest { (request: VNRequest, error: Error?) in
        guard let results = request.results as? [VNRectangleObservation],
              let rectangleObservation = results.first else {
          continuation.resume(returning: nil); return
        }
        
        Task {
          await self.updateRecentScanResult(rectangleObservation)
          let rect = await self.transformBoundingBox(rectangleObservation, to: previewSize)
          continuation.resume(returning: rect)
        }
      }
      
      request.minimumAspectRatio = 0.3
      request.maximumAspectRatio = 0.9
      request.minimumSize = 0.3
      request.maximumObservations = 1
      request.minimumConfidence = 0.8
      
      let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
      do {
        try handler.perform([request])
      } catch {
        continuation.resume(throwing: error)
      }
    }
  }
  
  func editImageWithScanResult(_ imageData: Data) -> CGImage? {
    guard var ciImage = CIImage(data: imageData)?.oriented(.right),
          let recentScanResult else { return nil }
    
    let topLeft = recentScanResult.topLeft.scaled(to: ciImage.extent.size)
    let topRight = recentScanResult.topRight.scaled(to: ciImage.extent.size)
    let bottomLeft = recentScanResult.bottomLeft.scaled(to: ciImage.extent.size)
    let bottomRight = recentScanResult.bottomRight.scaled(to: ciImage.extent.size)

    ciImage = ciImage.applyingFilter("CIPerspectiveCorrection", parameters: [
      "inputTopLeft": CIVector(cgPoint: topLeft),
      "inputTopRight": CIVector(cgPoint: topRight),
      "inputBottomLeft": CIVector(cgPoint: bottomLeft),
      "inputBottomRight": CIVector(cgPoint: bottomRight),
    ])

    let context = CIContext()
    return context.createCGImage(ciImage, from: ciImage.extent)
  }
  
  private func transformBoundingBox(_ rectangleObservation: VNRectangleObservation, to previewSize: CGRect) -> CGRect {
    let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -previewSize.height)
    let scale = CGAffineTransform.identity.scaledBy(x: previewSize.width, y: previewSize.height)

    return rectangleObservation.boundingBox.applying(scale).applying(transform)
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

