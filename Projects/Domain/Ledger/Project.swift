import ProjectDescription

let project = Project(
    name: "LedgerDomain",
    targets: [
        Target(
            name: "LedgerDomain",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.LedgerDomain",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Sources/**"],
            dependencies: [
            ]
        )
    ]
)
