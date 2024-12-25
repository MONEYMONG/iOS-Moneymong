import ProjectDescription

let project = Project(
    name: "Auth",
    settings: .settings(
        base: .init()
        .swiftVersion("5.7")
    ),
    targets: [
        Target(
            name: "Auth",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.Auth",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Sources/**"],
            dependencies: [
                .target(name: "AuthInterface")
            ]
        ),
        Target(
            name: "AuthInterface",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.AuthInterface",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Interface/**"],
            dependencies: [
            ]
        ),
        Target(
            name: "AuthTests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "com.framework.moneymong.AuthTests",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "Auth"),
                .target(name: "AuthTesting")
            ]
        ),
        Target(
            name: "AuthTesting",
            platform: .iOS,
            product: .staticLibrary,
            bundleId: "com.framework.moneymong.AuthTesting",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Testing/**"],
            dependencies: [
                .target(name: "AuthInterface")
            ]
        )
    ]
)
