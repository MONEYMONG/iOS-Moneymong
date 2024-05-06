import Foundation
import AuthenticationServices

import Utility

public final class AppleAuthManager: NSObject {

  var continuation: CheckedContinuation<String, Error>?

  public func sign() async throws -> String {
    return try await withCheckedThrowingContinuation { continuation in
      self.continuation = continuation

      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]

      let authController = ASAuthorizationController(authorizationRequests: [request])
      authController.delegate = self
      authController.presentationContextProvider = self
      authController.performRequests()
    }
  }
}

extension AppleAuthManager: ASAuthorizationControllerPresentationContextProviding {
  public func presentationAnchor(
    for controller: ASAuthorizationController
  ) -> ASPresentationAnchor {
    return UIWindow.firstWindow!
  }
}

extension AppleAuthManager: ASAuthorizationControllerDelegate {
  public func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    guard let appIDCredntial = authorization.credential as? ASAuthorizationAppleIDCredential,
    let authorizationCode = appIDCredntial.authorizationCode,
    let authorizationCodeString = String(data: authorizationCode, encoding: .utf8) else {
      debugPrint("Invalid Apple Code Error")
      return
    }
    continuation?.resume(returning: authorizationCodeString)
  }

  public func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithError error: Error
  ) {
    debugPrint("apple login 실패 \(error.localizedDescription)")
  }
}
