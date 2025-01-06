import ProjectDescription

let project = Project(
    name: "Agency",
    settings: .settings(
        base: .init()
        .swiftVersion("5.7")
    ),
    targets: [
        Target(
            name: "Agency",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.Agency",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Sources/**"],
            dependencies: [
                .target(name: "AgencyInterface"),
                .project(target: "Core", path: .relativeToRoot("Projects/Core/Core"))
            ]
        ),
        Target(
            name: "AgencyInterface",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.AgencyInterface",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Interface/**"],
            dependencies: [
            ]
        ),
        Target(
            name: "AgencyTests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "com.framework.moneymong.AgencyTests",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "Agency"),
                .target(name: "AgencyTesting")
            ]
        ),
        Target(
            name: "AgencyTesting",
            platform: .iOS,
            product: .staticLibrary,
            bundleId: "com.framework.moneymong.AgencyTesting",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Testing/**"],
            dependencies: [
                .target(name: "AgencyInterface")
            ]
        )
    ]
)
