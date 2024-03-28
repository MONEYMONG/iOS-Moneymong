import ProjectDescription

let project = Project(
    name: "AgencyDomain",
    targets: [
        Target(
            name: "AgencyDomain",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.AgencyDomain",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Sources/**"],
            dependencies: [
            ]
        )
    ]
)
