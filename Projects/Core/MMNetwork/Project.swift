import ProjectDescription

let project = Project(
    name: "MMNetwork",
    settings: .settings(
        base: .init()
        .swiftVersion("5.7")
    ),
    targets: [
        Target(
            name: "MMNetwork",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.MMNetwork",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Sources/**"],
            dependencies: [
                .target(name: "MMNetworkInterface")
            ]
        ),
        Target(
            name: "MMNetworkInterface",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.MMNetworkInterface",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Interface/**"],
            dependencies: [
              .project(target: "Utility", path: .relativeToRoot("Projects/Shared/Utility")),
              .project(target: "ThirdPartyLips", path: .relativeToRoot("Projects/Shared/ThirdPartyLips"))
            ]
        ),
        Target(
            name: "MMNetworkTests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "com.framework.moneymong.MMNetworkTests",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "MMNetwork"),
                .target(name: "MMNetworkTesting")
            ]
        ),
        Target(
            name: "MMNetworkTesting",
            platform: .iOS,
            product: .staticLibrary,
            bundleId: "com.framework.moneymong.MMNetworkTesting",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Testing/**"],
            dependencies: [
                .target(name: "MMNetworkInterface")
            ]
        )
    ]
)
