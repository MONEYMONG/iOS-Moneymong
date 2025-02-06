import AuthInterface
import BaseDomain
import Utility

public struct SignUpUseCase: SignUpUseCaseInterface {
  private let signRepo: SignRepositoryInterface
  private let userRepo: UserRepositoryInterface
  
  public init(signRepo: SignRepositoryInterface, userRepo: UserRepositoryInterface) {
    self.signRepo = signRepo
    self.userRepo = userRepo
  }
  
  public func execute(loginType: LoginType) async throws -> SignInfo {
    let signInfo: SignInfo
    switch loginType {
    case .kakao:
      let authInfo = try await signRepo.kakaoSign()
      signInfo = try await signRepo.sign(
        provider: loginType.value,
        accessToken: authInfo.accessToken,
        name: nil,
        code: nil
      )
    case .apple:
      let authInfo = try await signRepo.appleSign()
      signInfo = try await signRepo.sign(
        provider: loginType.value,
        accessToken: authInfo.idToken,
        name: authInfo.name,
        code: authInfo.authorizationCode
      )
    }
    let userInfo = try await userRepo.user()
    
    if signInfo.schoolInfoExist {
      FirebaseManager.shared.logEvent(
        event: .login,
        parameters: [
          "user_id" : userInfo.id,
          "nickname" : userInfo.nickname,
          "email" : userInfo.email,
          "university_name" : userInfo.universityName,
          "grade" : userInfo.grade,
          "provider" : signInfo.schoolInfoExist ? "APPLE" : "KAKAO"
        ]
      )
    } else {
      FirebaseManager.shared.logEvent(
        event: .signUp,
        parameters: [
          "user_id" : userInfo.id,
          "nickname" : userInfo.nickname,
          "email" : userInfo.email,
          "provider" : signInfo.schoolInfoExist ? "APPLE" : "KAKAO"
        ]
      )
    }
    
    return signInfo
  }
}
