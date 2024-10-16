import ProjectDescription

let project = Project(
  name: "Core",
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
      name: "Core",
      platform: .iOS,
      product: .framework,
      bundleId: "com.framework.moneymong.Core",
      deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: [
        .project(target: "Utility", path: .relativeToRoot("Projects/Core/Utility")),
        .project(target: "ThirdPartyLips", path: .relativeToRoot("Projects/Shared/ThirdPartyLips")),
        .package(product: "FirebaseAnalytics"),
        .package(product: "FirebaseDynamicLinks"),
        .package(product: "FirebaseMessaging")
      ],
      settings: .settings(base: [
        "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
        "OTHER_LDFLAGS": "-ObjC",
        "SWIFT_VERSION": "5.7"
      ]),
      launchArguments: [
        LaunchArgument(name: "IDEPreferLogStreaming=YES", isEnabled: true),
        LaunchArgument(name: "-FIRDebugEnabled", isEnabled: true)
      ]
    )
  ]
)
