import ProjectDescription

let project = Project(
  name: "Core",
  options: .options(
    disableBundleAccessors: true,
    disableSynthesizedResourceAccessors: true
  ),
  targets: [
    Target(
      name: "Core",
      platform: .iOS,
      product: .framework,
      bundleId: "com.framework.moneymong.Core",
      deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
      sources: ["Sources/**"],
      dependencies: [
        .project(target: "NetworkService", path: .relativeToRoot("Projects/Core/Network")),
        .project(target: "LocalStorage", path: .relativeToRoot("Projects/Core/LocalStorage")),
        .project(target: "Utility", path: .relativeToRoot("Projects/Core/Utility"))
      ]
    )
  ]
)
