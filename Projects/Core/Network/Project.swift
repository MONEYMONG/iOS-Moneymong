import ProjectDescription

let project = Project(
  name: "NetworkService",
  options: .options(
    disableBundleAccessors: true,
    disableSynthesizedResourceAccessors: true
  ),
  packages: [
    .remote(
      url: "https://github.com/firebase/firebase-ios-sdk",
      requirement: .upToNextMajor(from: "10.28.0")
    )
  ],
  targets: [
    Target(
      name: "NetworkService",
      platform: .iOS,
      product: .framework,
      bundleId: "com.framework.moneymong.NetworkService",
      deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: [
        .project(target: "ThirdPartyLips", path: .relativeToRoot("Projects/Shared/ThirdPartyLips")),
        .package(product: "FirebaseDynamicLinks"),
        .package(product: "FirebaseMessaging"),
        .package(product: "FirebaseAnalytics")
      ],
      launchArguments: [
        LaunchArgument(name: "IDEPreferLogStreaming=YES", isEnabled: true),
        LaunchArgument(name: "-FIRDebugEnabled", isEnabled: true),
      ]
    )
  ]
)
