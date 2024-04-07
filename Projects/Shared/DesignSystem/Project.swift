import ProjectDescription

let project = Project(
  name: "DesignSystem",
  options: .options(
    disableBundleAccessors: true,
    disableSynthesizedResourceAccessors: true
  ),
  packages: [
    .remote(
      url: "https://github.com/layoutBox/FlexLayout",
      requirement: .upToNextMajor(from: "2.0.07")
    ),
    .remote(
      url: "https://github.com/layoutBox/PinLayout",
      requirement: .upToNextMajor(from: "1.10.5")
    )
  ],
  targets: [
    Target(
      name: "DesignSystem",
      platform: .iOS,
      product: .framework,
      bundleId: "com.framework.moneymong.DesignSystem",
      deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: [
        .package(product: "FlexLayout"),
        .package(product: "PinLayout")
      ]
    ),
    Target(
      name: "DesignSystemDemo",
      platform: .iOS,
      product: .app,
      bundleId: "com.framework.moneymong.DesignSystemDemo",
      deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
      infoPlist: .extendingDefault(with: [
        "CFBundleShortVersionString": "1.0",
        "CFBundleVersion": "1",
        "UILaunchStoryboardName": "LaunchScreen"
      ]),
      sources: ["Demo/Sources/**"],
      resources: ["Demo/Resources/**"],
      dependencies: [
        .target(name: "DesignSystem")
      ]
    )
  ],
  resourceSynthesizers: []
)
