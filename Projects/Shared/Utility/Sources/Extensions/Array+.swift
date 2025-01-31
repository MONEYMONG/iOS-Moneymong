import Foundation

public extension Array {
  subscript(safe index: Int) -> Element? {
    indices ~= index ? self[index] : nil
  }
}

