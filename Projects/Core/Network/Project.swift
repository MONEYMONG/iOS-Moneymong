import ProjectDescription

let project = Project(
  name: "Network",
  options: .options(
    disableBundleAccessors: true,
    disableSynthesizedResourceAccessors: true
  ),
  targets: [
    Target(
      name: "Network",
      platform: .iOS,
      product: .framework,
      bundleId: "com.framework.moneymong.Network",
      deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
      sources: ["Sources/**"],
      dependencies: [
        .external(name: "Moya"),
      ]
    )
  ]
)
