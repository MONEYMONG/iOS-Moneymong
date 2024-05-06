import Foundation

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import RxSwift

public final class KakaoAuthManager {
  public static var shared = KakaoAuthManager()

  private let nativeKey = "5412cf7a0e53089ab63f4e04b10622c5"

  public init() {}

  public func initSDK() {
    KakaoSDK.initSDK(appKey: nativeKey)
  }

  public func openURL(_ url: URL) {
    if AuthApi.isKakaoTalkLoginUrl(url) {
      _ = AuthController.handleOpenUrl(url: url)
    }
  }

  // Device에 KakaoTalk App 사용 가능한지 여부 체크
  // 1. true = App에 접근해 인증정보 활용
  // 2. false = KakaoTalk 계정 유저에게 입력받아서 활용
  public func sign() async throws -> String {
    return try await withCheckedThrowingContinuation { continuation in
      if UserApi.isKakaoTalkLoginAvailable() {
        Task { try await kakaoAppSign(continuation: continuation) }
      } else {
        Task { try await kakaoWebSign(continuation: continuation) }
      }
    }
  }
}

extension KakaoAuthManager {
  private func kakaoAppSign(continuation: CheckedContinuation<String, any Error>) async throws {
    UserApi.shared.loginWithKakaoTalk { oauthToken, error in
      if let kakaoError = error as? SdkError {
        let reason = kakaoError.getClientError().reason
        if reason == .Cancelled { return }
        continuation.resume(throwing: MoneyMongError.unknown(kakaoError.localizedDescription))
      }
      if let accessToken = oauthToken?.accessToken {
        continuation.resume(returning: accessToken)
      }
    }
  }

  private func kakaoWebSign(continuation: CheckedContinuation<String, any Error>) async throws {
    UserApi.shared.loginWithKakaoAccount { oauthToken, error in
      if let kakaoError = error as? SdkError {
        let reason = kakaoError.getClientError().reason
        if reason == .Cancelled { return }
        continuation.resume(throwing: MoneyMongError.unknown(kakaoError.localizedDescription))
      }
      if let accessToken = oauthToken?.accessToken {
        continuation.resume(returning: accessToken)
      }
    }
  }
}
