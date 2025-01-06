import UIKit

public protocol MyPageFactoryInterface {
  func makeMyPageVC() -> UIViewController
  func makeWithdrawalVC() -> UIViewController
}
