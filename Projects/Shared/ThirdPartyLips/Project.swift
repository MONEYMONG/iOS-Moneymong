import ProjectDescription

let project = Project(
  name: "ThirdPartyLips",
  options: .options(
    disableBundleAccessors: true,
    disableSynthesizedResourceAccessors: true
  ),
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
        .external(name: "RxDataSources"),
        .external(name: "Alamofire"),
        .external(name: "KakaoSDKUser")
      ],
      settings: .settings(base: [
        "SWIFT_VERSION": "5.7"
      ])
    )
  ]
)
