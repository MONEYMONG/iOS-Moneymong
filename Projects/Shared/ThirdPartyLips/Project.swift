import ProjectDescription

let project = Project(
  name: "ThirdPartyLips",
  options: .options(
    disableBundleAccessors: true,
    disableSynthesizedResourceAccessors: true
  ),
  packages: [
    .remote(
      url: "https://github.com/onevcat/Kingfisher",
      requirement: .upToNextMajor(from: "8.0.1")
    )
  ],
  targets: [
    Target(
      name: "ThirdPartyLips",
      platform: .iOS,
      product: .framework,
      bundleId: "com.framework.moneymong.ThirdPartyLips",
      deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
      sources: ["Sources/**"],
      dependencies: [
        .external(name: "ReactorKit"),
        .package(product: "Kingfisher"),
        .external(name: "RxCocoa"),
        .external(name: "RxDataSources"),
        .external(name: "Alamofire"),
        .external(name: "KakaoSDKAuth"),
        .external(name: "KakaoSDKUser")
//        .external(name: "Pulse"),
//        .external(name: "PulseUI")
      ],
      settings: .settings(base: [
        "SWIFT_VERSION": "5.7"
      ])
    )
  ]
)
