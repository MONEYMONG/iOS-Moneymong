import ProjectDescription

let dependencies = Dependencies(
  swiftPackageManager: .init([
    .remote(
      url: "https://github.com/ReactorKit/ReactorKit",
      requirement: .upToNextMajor(from: "3.2.0")
    ),
    .remote(
      url: "https://github.com/Alamofire/Alamofire",
      requirement: .upToNextMajor(from: "5.9.1")
    ),
    .remote(
      url: "https://github.com/onevcat/Kingfisher",
      requirement: .upToNextMajor(from: "7.11.0")
    ),
    .remote(
      url: "https://github.com/ReactiveX/RxSwift",
      requirement: .upToNextMajor(from: "6.6.0")
    ),
    .remote(
      url: "https://github.com/RxSwiftCommunity/RxDataSources",
      requirement: .upToNextMajor(from: "5.0.2")
    ),
    .remote(
      url: "https://github.com/kakao/kakao-ios-sdk",
      requirement: .branch("master"))
    )
  ])
  ,platforms: [.iOS]
)
