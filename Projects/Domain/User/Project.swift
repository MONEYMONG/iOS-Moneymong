import ProjectDescription

let project = Project(
    name: "UserDomain",
    targets: [
        Target(
            name: "UserDomain",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.UserDomain",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Sources/**"],
            dependencies: [
              .project(target: "Network", path: "../../Core/Network")
            ]
        )
    ]
)
