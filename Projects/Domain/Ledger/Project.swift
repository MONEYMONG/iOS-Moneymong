import ProjectDescription

let project = Project(
    name: "Ledger",
    settings: .settings(
        base: .init()
        .swiftVersion("5.7")
    ),
    targets: [
        Target(
            name: "Ledger",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.Ledger",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Sources/**"],
            dependencies: [
                .target(name: "LedgerInterface")
            ]
        ),
        Target(
            name: "LedgerInterface",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.LedgerInterface",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Interface/**"],
            dependencies: [
              .project(target: "BaseDomain", path: .relativeToRoot("Projects/Domain/BaseDomain"))
            ]
        ),
        Target(
            name: "LedgerTests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "com.framework.moneymong.LedgerTests",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "Ledger"),
                .target(name: "LedgerTesting"),
                .project(target: "CoreTesting", path: .relativeToRoot("Projects/Core/Core"))
            ]
        ),
        Target(
            name: "LedgerTesting",
            platform: .iOS,
            product: .staticLibrary,
            bundleId: "com.framework.moneymong.LedgerTesting",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Testing/**"],
            dependencies: [
                .target(name: "LedgerInterface")
            ]
        )
    ]
)
