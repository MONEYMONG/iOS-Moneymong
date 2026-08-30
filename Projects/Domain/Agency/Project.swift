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
                .target(name: "AgencyInterface")
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
              .project(target: "BaseDomain", path: .relativeToRoot("Projects/Domain/BaseDomain"))
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
                .target(name: "AgencyTesting"),
                .project(target: "BaseDomainTesting", path: .relativeToRoot("Projects/Domain/BaseDomain")),
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
