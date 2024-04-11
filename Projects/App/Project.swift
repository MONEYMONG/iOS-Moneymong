import ProjectDescription

let project = Project(
  name: "Moneymong",
  options: .options(
    disableBundleAccessors: true,
    disableSynthesizedResourceAccessors: true
  ),
  targets: [
    Target(
      name: "Moneymong",
      platform: .iOS,
      product: .app,
      bundleId: "com.team.moneymong",
      deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
      infoPlist: .extendingDefault(with: [
        "CFBundleShortVersionString": "1.0",
        "CFBundleVersion": "1",
        "UILaunchStoryboardName": "LaunchScreen"
      ]),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: [
        .project(target: "SignFeature", path: .relativeToRoot("Projects/Feature/Sign")),
        .project(target: "MainFeature", path: .relativeToRoot("Projects/Feature/Main")),
        .project(target: "AgencyFeature", path: .relativeToRoot("Projects/Feature/Agency")),
        .project(target: "MyPageFeature", path: .relativeToRoot("Projects/Feature/MyPage")),
        .project(target: "LedgerFeature", path: .relativeToRoot("Projects/Feature/Ledger"))
      ]
    )
  ]
)
