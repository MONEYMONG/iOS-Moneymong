import Foundation

/// 유저정보
public struct UserResponseDTO: Responsable {
  let id: Int?
  let userToken: String?
  let nickname: String?
  let email: String?
  let universityName: String?
  let grade: Int?
  let provider: String?
  
  public var toEntity: UserInfo {
    .init(
      id: id ?? -1,
      nickname: nickname ?? "닉네임 정보 없음",
      email: email ?? "이메일 정보 없음",
      universityName: universityName ?? "대학정보없음",
      grade: grade ?? 0,
      provider: self.provider ?? "KAKAO"
    )
  }
  
  public static var mock: Self {
    .init(
      id: -1,
      userToken: "-1",
      nickname: "dudu",
      email: "dudu@naver.com",
      universityName: "머니몽대학교",
      grade: 1,
      provider: "KAKAO"
    )
  }
}
