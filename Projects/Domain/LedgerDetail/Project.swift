import ProjectDescription

let project = Project(
    name: "LedgerDetailDomain",
    targets: [
        Target(
            name: "LedgerDetailDomain",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.LedgerDetailDomain",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Sources/**"],
            dependencies: [
            ]
        )
    ]
)
