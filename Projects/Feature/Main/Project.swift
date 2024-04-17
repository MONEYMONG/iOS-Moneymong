import ProjectDescription

let project = Project(
    name: "MainFeature",
    options: .options(
      disableBundleAccessors: true,
      disableSynthesizedResourceAccessors: true
    ),
    targets: [
        Target(
            name: "MainFeature",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.MainFeature",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Sources/**"],
            dependencies: [
              .project(target: "BaseFeature", path: .relativeToRoot("Projects/Feature/Base")),
                .project(target: "MyPageFeature", path: .relativeToRoot("Projects/Feature/MyPage")),
                .project(target: "AgencyFeature", path: .relativeToRoot("Projects/Feature/Agency")),
                .project(target: "LedgerFeature", path: .relativeToRoot("Projects/Feature/Ledger"))
            ]
        ),
        Target(
            name: "MainFeatureTests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "com.framework.moneymong.MainFeatureTests",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "MainFeature")
            ]
        ),
        Target(
            name: "MainFeatureDemo",
            platform: .iOS,
            product: .app,
            bundleId: "com.framework.moneymong.MainFeatureDemo",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            infoPlist: .extendingDefault(with: [
                "CFBundleShortVersionString": "1.0",
                "CFBundleVersion": "1",
                "UILaunchStoryboardName": "LaunchScreen"
            ]),
            sources: ["Demo/Sources/**"],
            resources: ["Demo/Resources/**"],
            dependencies: [
                .target(name: "MainFeature")
            ]
        )
    ]
)
