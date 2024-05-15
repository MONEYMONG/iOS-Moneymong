/// 장부 목록 내역에 사용되는 모델
///
/// - Parameters:
///  - id: 장부 상세 내역 api에 사용되는 값
///  - order: 장부 내역 시간 순으로 정렬된 값 장부 목록 ui에 사용되는 값
public struct Ledger {
  public let id: Int
  public let storeInfo: String
  public let fundType: FundType
  public let amount: Int
  public let balance: Int
  public let order: Int
  public let paymentDate: String
}
