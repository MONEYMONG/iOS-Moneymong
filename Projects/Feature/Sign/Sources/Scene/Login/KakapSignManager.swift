import KakaoSDKUser
import RxSwift

protocol KakaoSignManagerInterface {
  func sign() -> Observable<String>
}

final class KakaoSignManager: KakaoSignManagerInterface {

  // Device에 KakaoTalk App 사용 가능한지 여부 체크
  // 1. true = App에 접근해 인증정보 활용
  // 2. false = KakaoTalk 계정 유저에게 입력받아서 활용
  func sign() -> Observable<String> {
    if UserApi.isKakaoTalkLoginAvailable() {
      return kakaoAppSign()
    } else {
      return kakaoWebSign()
    }
  }
}

extension KakaoSignManager {
  private func kakaoAppSign() -> Observable<String> {
    return Observable.create { observer in
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

  private func kakaoWebSign() -> Observable<String> {
    return Observable.create { observer in
      UserApi.shared.loginWithKakaoAccount { oauthToken, error in
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
