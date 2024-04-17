import Foundation

private class MMBundle {}

extension Foundation.Bundle {
  static var module: Bundle = {
    return Bundle(for: MMBundle.self)
  }()
}
