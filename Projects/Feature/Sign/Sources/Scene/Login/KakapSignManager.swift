import KakaoSDKUser
import RxSwift

protocol KakaoSignManagerInterface {
  func login() -> Observable<String>
}

final class KakaoSignManager: KakaoSignManagerInterface {
  func login() -> Observable<String> {
    return Observable.create { observer in

//      guard UserApi.isKakaoTalkLoginAvailable() else {
//        return Disposables.create()
//      }

      UserApi.shared.loginWithKakaoTalk { oauthToken, error in
        guard let idToken = oauthToken?.accessToken else {
          observer.onNext(error?.localizedDescription ?? "")
          return
        }
        observer.onNext(idToken)
      }
      return Disposables.create()
    }
  }
}
