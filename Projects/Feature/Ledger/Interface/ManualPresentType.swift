import Foundation

import BaseDomain

public enum ManualPresentType {
  case operatingCost // 운영비 등록화면
  case ocrResultEdit(OCRResult, Data) // ocr 결과 수정화면
  case createManual
}
