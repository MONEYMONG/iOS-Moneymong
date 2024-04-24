import Foundation
import AuthenticationServices

import RxSwift

public final class AppleAuthManager: NSObject {

  private var authorizationObserver: AnyObserver<String>? {
    didSet {
      if let authorization = self.authorization {
        authorizationObserver?.onNext(authorization)
      }
    }
  }

  private var authorization: String? {
    didSet {
      authorizationObserver?.onNext(authorization!)
    }
  }

  var keyWindow: UIWindow? {
    return UIApplication.shared.connectedScenes
      .filter { $0.activationState == .foregroundActive }
      .map { $0 as? UIWindowScene }
      .compactMap { $0 }
      .first?.windows
      .filter { $0.isKeyWindow }.first
  }

  func requestLogin() -> Observable<String> {
    return Observable.create { observer in
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]

      let authController = ASAuthorizationController(authorizationRequests: [request])
      authController.delegate = self
      authController.presentationContextProvider = self
      authController.performRequests()

      self.authorizationObserver = observer

      return Disposables.create {
        authController.delegate = nil
        authController.presentationContextProvider = nil
      }
    }
  }
}

extension AppleAuthManager: ASAuthorizationControllerPresentationContextProviding {
  public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return keyWindow!
  }
}

extension AppleAuthManager: ASAuthorizationControllerDelegate {
  public func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    guard let appIDCredntial = authorization.credential as? ASAuthorizationAppleIDCredential else {
      return
    }
    let accessToken = appIDCredntial.user
    authorizationObserver?.onNext(accessToken)
    authorizationObserver?.onCompleted()
  }

  public func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithError error: Error
  ) {
    authorizationObserver?.onError(error)
  }
}
