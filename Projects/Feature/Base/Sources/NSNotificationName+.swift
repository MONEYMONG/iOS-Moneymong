import Foundation

public extension NSNotification.Name {
  static let tabBarHidden = NSNotification.Name("tabBarHidden") // toggle Tab
  static let presentManualCreater = NSNotification.Name("presentManualCreater") // 동아리 운영비 등록화면 present
  static let presentOCRCreater = NSNotification.Name("presentOCRCreater") // 동아리 운영비 OCR 스캔화면 present
}
