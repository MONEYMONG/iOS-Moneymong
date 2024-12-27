import Foundation

/// 유저정보
public struct UserInfo: Equatable {
  public let id: Int // 유저 아이디
  public let nickname: String // 닉네임
  public let email: String // 이메일
  public let universityName: String // 대학교명
  public let grade: Int // 학년
  public let provider: String // APPLE OR KAKAO
  
  public init(
    id: Int,
    nickname: String,
    email: String,
    universityName: String,
    grade: Int,
    provider: String
  ) {
    self.id = id
    self.nickname = nickname
    self.email = email
    self.universityName = universityName
    self.grade = grade
    self.provider = provider
  }
}
