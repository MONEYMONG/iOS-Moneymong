import ProjectDescription

let project = Project(
    name: "MMStorage",
    settings: .settings(
        base: .init()
        .swiftVersion("5.7")
    ),
    targets: [
        Target(
            name: "MMStorage",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.MMStorage",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Sources/**"],
            dependencies: [
                .target(name: "MMStorageInterface")
            ]
        ),
        Target(
            name: "MMStorageInterface",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.MMStorageInterface",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Interface/**"],
            dependencies: [
            ]
        ),
        Target(
            name: "MMStorageTests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "com.framework.moneymong.MMStorageTests",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "MMStorage"),
                .target(name: "MMStorageTesting")
            ]
        ),
        Target(
            name: "MMStorageTesting",
            platform: .iOS,
            product: .staticLibrary,
            bundleId: "com.framework.moneymong.MMStorageTesting",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Testing/**"],
            dependencies: [
                .target(name: "MMStorageInterface")
            ]
        )
    ]
)
