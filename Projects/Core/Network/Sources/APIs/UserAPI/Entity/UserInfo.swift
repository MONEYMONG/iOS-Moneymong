import Foundation

/// 유저정보
public struct UserInfo: Equatable {
  public let nickname: String // 닉네임
  public let email: String // 이메일
  public let universityName: String // 대학교명
  public let grade: Int // 학년
  
  public init(
    nickname: String,
    email: String,
    universityName: String,
    grade: Int
  ) {
    self.nickname = nickname
    self.email = email
    self.universityName = universityName
    self.grade = grade
  }
}
