import ProjectDescription

let project = Project(
    name: "DesignSystem",
    targets: [
        Target(
            name: "DesignSystem",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.DesignSystem",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Sources/**"],
            dependencies: [
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
    ]
)
