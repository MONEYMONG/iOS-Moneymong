import ProjectDescription

let project = Project(
    name: "User",
    settings: .settings(
        base: .init()
        .swiftVersion("5.7")
    ),
    targets: [
        Target(
            name: "User",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.User",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Sources/**"],
            dependencies: [
                .target(name: "UserInterface")
            ]
        ),
        Target(
            name: "UserInterface",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.UserInterface",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Interface/**"],
            dependencies: [
              .project(target: "BaseDomain", path: .relativeToRoot("Projects/Domain/BaseDomain"))
            ]
        ),
        Target(
            name: "UserTests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "com.framework.moneymong.UserTests",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "User"),
                .target(name: "UserTesting"),
                .project(target: "CoreTesting", path: .relativeToRoot("Projects/Core/Core"))
            ]
        ),
        Target(
            name: "UserTesting",
            platform: .iOS,
            product: .staticLibrary,
            bundleId: "com.framework.moneymong.UserTesting",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Testing/**"],
            dependencies: [
                .target(name: "UserInterface")
            ]
        )
    ]
)
