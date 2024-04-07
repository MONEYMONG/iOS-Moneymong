import ProjectDescription

let project = Project(
  name: "Utils",
  targets: [
    Target(
      name: "Utils",
      platform: .iOS,
      product: .framework,
      bundleId: "com.framework.moneymong.Utils",
      deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
      sources: ["Sources/**"],
      dependencies: [
      ]
    )
  ]
)
