import ProjectDescription

let project = Project(
  name: "NetworkService",
  options: .options(
    disableBundleAccessors: true,
    disableSynthesizedResourceAccessors: true
  ),
  targets: [
    Target(
      name: "NetworkService",
      platform: .iOS,
      product: .framework,
      bundleId: "com.framework.moneymong.Network",
      deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
      sources: ["Sources/**"],
      dependencies: [
        .project(target: "ThirdPartyLips", path: .relativeToRoot("Projects/Shared/ThirdPartyLips")),
      ]
    )
  ]
)
