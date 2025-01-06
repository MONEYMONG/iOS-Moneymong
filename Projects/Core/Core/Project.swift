import ProjectDescription

let project = Project(
  name: "Core",
  options: .options(
    disableBundleAccessors: true,
    disableSynthesizedResourceAccessors: true
  ),
  settings: .settings(base: [
    "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
    "OTHER_LDFLAGS": "-ObjC",
    "SWIFT_VERSION": "5.7"
  ]),
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
        .project(target: "UserInterface", path: .relativeToRoot("Projects/Domain/User")),
        .project(target: "AuthInterface", path: .relativeToRoot("Projects/Domain/Auth")),
        .project(target: "AgencyInterface", path: .relativeToRoot("Projects/Domain/Agency")),
        .project(target: "LedgerInterface", path: .relativeToRoot("Projects/Domain/Ledger"))
      ],
      launchArguments: [
        LaunchArgument(name: "IDEPreferLogStreaming=YES", isEnabled: true),
        LaunchArgument(name: "-FIRDebugEnabled", isEnabled: true)
      ]
    ),
    Target(
        name: "CoreTesting",
        platform: .iOS,
        product: .staticLibrary,
        bundleId: "com.framework.moneymong.CoreTesting",
        deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
        sources: ["Testing/**"],
        dependencies: [
            .target(name: "Core")
        ]
    )
  ]
)
