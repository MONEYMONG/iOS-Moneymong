import Foundation
import AuthenticationServices

import Utility

public final class AppleAuthManager: NSObject {

  var continuation: CheckedContinuation<AppleAuthInfo, Error>?

  public func sign() async throws -> AppleAuthInfo {
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
          let idTokenData = appIDCredntial.identityToken,
          let idToken = String(data: idTokenData, encoding: .utf8),
          let authorizationCodeData = appIDCredntial.authorizationCode,
          let authorizationCode = String(data: authorizationCodeData, encoding: .utf8),
          let name = appIDCredntial.fullName
    else {
      continuation?
        .resume(throwing: MoneyMongError.unknown("유저 정보를 가져오지 못했습니다."))
      return
    }
    guard let familyName = name.familyName,
          let givenName = name.givenName
    else {
      let authInfo = AppleAuthInfo(
        idToken: idToken,
        authorizationCode: authorizationCode
      )
      continuation?.resume(returning: authInfo)
      return
    }
    let authInfo = AppleAuthInfo(
      idToken: idToken,
      name: familyName + givenName,
      authorizationCode: authorizationCode
    )
    continuation?.resume(returning: authInfo)
  }

  public func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithError error: Error
  ) {
    /// 사용자 로그인 취소에 의한 에러 발생시 무시
    if let appleError = error as? ASAuthorizationError,
       appleError.code.rawValue == 1001 {
      return
    }
    continuation?
      .resume(throwing: MoneyMongError.unknown(error.localizedDescription))
  }
}
