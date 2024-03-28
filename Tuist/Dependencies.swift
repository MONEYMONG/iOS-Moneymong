import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: .init([
        .remote(
            url: "https://github.com/ReactorKit/ReactorKit",
            requirement: .upToNextMajor(from: "3.2.0")
        ),
        .remote(
            url: "https://github.com/layoutBox/FlexLayout",
            requirement: .upToNextMajor(from: "2.0.0")
        ),
        .remote(
            url: "https://github.com/layoutBox/PinLayout",
            requirement: .upToNextMajor(from: "1.10.0")
        ),
        .remote(
            url: "https://github.com/Moya/Moya",
            requirement: .upToNextMajor(from: "15.0.0")
        ),
        .remote(
            url: "https://github.com/onevcat/Kingfisher",
            requirement: .upToNextMajor(from: "7.11.0")
        ),
        .remote(
            url: "https://github.com/ReactiveX/RxSwift",
            requirement: .upToNextMajor(from: "6.6.0")
        )
    ])
)
