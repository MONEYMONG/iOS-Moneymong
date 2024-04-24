import Foundation
import NetworkService

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
  public func sign() -> Observable<String> {
    if UserApi.isKakaoTalkLoginAvailable() {
      return kakaoAppSign()
    } else {
      return kakaoWebSign()
    }
  }
}

extension KakaoAuthManager {
  private func kakaoAppSign() -> Observable<String> {
    return Observable.create { observer in
      UserApi.shared.loginWithKakaoTalk { oauthToken, error in
        if let error {
          observer.onError(error)
          return
        }
        if let idToken = oauthToken?.idToken {
          observer.onNext(idToken)
        } else {
          observer.onError(KakaoSDKCommon.SdkError.AuthFailed(reason: .Unknown, errorInfo: nil))
        }
      }
      return Disposables.create()
    }
  }

  private func kakaoWebSign() -> Observable<String> {
    return Observable.create { observer in
      UserApi.shared.loginWithKakaoAccount { oauthToken, error in
        if let error {
          observer.onError(error)
          return
        }
        if let idToken = oauthToken?.accessToken {
          observer.onNext(idToken)
        } else {
          observer.onError(MoneyMongError.unknown("유저 id 없음"))
        }
      }
      return Disposables.create()
    }
  }
}
