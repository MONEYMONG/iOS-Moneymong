import Foundation

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import RxSwift

public final class KakaoAuthManager {
  public static var shared = KakaoAuthManager()

  private let nativeKey = "e36cd3af5a109d7d1ac6fbc96c7ee318"

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
        if let idToken = oauthToken?.idToken {
          observer.onNext(idToken)
        }
      }
      return Disposables.create()
    }
  }

//  private func requestUserId() -> Observable<Int> {
//    return Observable.create { observer in
//      UserApi.shared.me { user, error in
//        if let error {
//          observer.onError(error)
//        }
//        if let userID = user?.id {
//          observer.onNext(Int(userID))
//        } else {
////          observer.onError(Erro)
//        }
//      }
//      return Disposables.create()
//    }
//  }
}
