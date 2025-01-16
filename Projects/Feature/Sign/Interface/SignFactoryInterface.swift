import UIKit

public protocol SignFactoryInterface {
  func makeSplash() -> UIViewController
  func makeLogin() -> UIViewController
  func makeCongratulation() -> UIViewController
}
