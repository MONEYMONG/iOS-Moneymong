import ProjectDescription

let project = Project(
    name: "BaseDomain",
    settings: .settings(
        base: .init()
        .swiftVersion("5.7")
    ),
    targets: [
        Target(
            name: "BaseDomain",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.BaseDomain",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Sources/**"],
            dependencies: [
              .project(target: "Utility", path: .relativeToRoot("Projects/Shared/Utility")),
              .project(target: "ThirdPartyLips", path: .relativeToRoot("Projects/Shared/ThirdPartyLips"))
            ]
        )
    ]
)
