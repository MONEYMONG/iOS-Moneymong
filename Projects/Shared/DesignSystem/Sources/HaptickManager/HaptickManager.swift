import UIKit

final class HapticManager {
 static let shared = HapticManager()

 private init() {}

 func hapticNotification(type: UINotificationFeedbackGenerator.FeedbackType) {
  let generator = UINotificationFeedbackGenerator()
  generator.notificationOccurred(type)
 }

 func hapticImpact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
  let generator = UIImpactFeedbackGenerator(style: style)
  generator.impactOccurred()
 }
}
