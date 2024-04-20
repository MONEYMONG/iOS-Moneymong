import ProjectDescription

let project = Project(
    name: "UserDomain",
    options: .options(
      disableBundleAccessors: true,
      disableSynthesizedResourceAccessors: true
    ),
    targets: [
        Target(
            name: "UserDomain",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.UserDomain",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Sources/**"],
            dependencies: [
              .project(target: "BaseDomain", path: .relativeToRoot("Projects/Domain/Base"))
            ]
        )
    ]
)
