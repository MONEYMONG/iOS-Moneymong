import ProjectDescription

let project = Project(
    name: "SignFeature",
    targets: [
        Target(
            name: "SignFeature",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.SignFeature",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Sources/**"],
            dependencies: [
              .project(target: "BaseFeature", path: .relativeToRoot("Projects/Feature/Base"))
            ]
        ),
        Target(
            name: "SignFeatureTests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "com.framework.moneymong.SignFeatureTests",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "SignFeature")
            ]
        ),
        Target(
            name: "SignFeatureDemo",
            platform: .iOS,
            product: .app,
            bundleId: "com.framework.moneymong.SignFeatureDemo",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            infoPlist: .extendingDefault(with: [
                "CFBundleShortVersionString": "1.0",
                "CFBundleVersion": "1",
                "UILaunchStoryboardName": "LaunchScreen"
            ]),
            sources: ["Demo/Sources/**"],
            resources: ["Demo/Resources/**"],
            dependencies: [
                .target(name: "SignFeature")
            ]
        )
    ]
)
