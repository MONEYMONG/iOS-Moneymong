import UIKit

public enum Fonts {
  public enum Weight: String, CaseIterable {
    case bold = "SpoqaHanSansNeo-Bold"
    case light = "SpoqaHanSansNeo-Light"
    case medium = "SpoqaHanSansNeo-Medium"
    case regular = "SpoqaHanSansNeo-Regular"
    case tint = "SpoqaHanSansNeo-Thin"
  }
  
  case heading
  case body
  
  public var _1: UIFont {
    switch self {
    case .heading: return UIFont.custom(.bold, size: 18)
    case .body: return UIFont.custom(.regular, size: 12)
    }
  }
  
  public var _2: UIFont {
    switch self {
    case .heading: return UIFont.custom(.bold, size: 20)
    case .body: return UIFont.custom(.medium, size: 12)
    }
  }
  
  public var _3: UIFont {
    switch self {
    case .heading: return UIFont.custom(.bold, size: 22)
    case .body: return UIFont.custom(.medium, size: 14)
    }
  }
  
  public var _4: UIFont {
    switch self {
    case .heading: return UIFont.custom(.bold, size: 24)
    case .body: return UIFont.custom(.medium, size: 16)
    }
  }
  
  public var _5: UIFont {
    switch self {
    case .heading: return UIFont.custom(.bold, size: 28)
    case .body: return UIFont.custom(.medium, size: 18)
    }
  }
  
  public static var caption: UIFont {
    return UIFont.custom(.regular, size: 10)
  }
  
  public static func registerFont() {
    Fonts.Weight.allCases.forEach {
      guard let url = Bundle.module.url(forResource: "\($0.rawValue)", withExtension: ".otf") else {
        return
      }
      CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }
  }
}

fileprivate extension UIFont {
  static func custom(_ weigth: Fonts.Weight, size: CGFloat) -> UIFont {
    return UIFont(name: weigth.rawValue, size: size) ?? .systemFont(ofSize: size)
  }
}
