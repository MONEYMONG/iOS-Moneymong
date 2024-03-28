import ProjectDescription

let project = Project(
    name: "UniversityDomain",
    targets: [
        Target(
            name: "UniversityDomain",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.UniversityDomain",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Sources/**"],
            dependencies: [
            ]
        )
    ]
)
