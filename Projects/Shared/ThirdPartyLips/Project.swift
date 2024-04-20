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
        .external(name: "Kingfisher"),
        .external(name: "RxCocoa"),
        .external(name: "RxDataSources")
      ]
    )
  ]
)
