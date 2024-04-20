import ProjectDescription

let project = Project(
    name: "BaseDomain",
    options: .options(
      disableBundleAccessors: true,
      disableSynthesizedResourceAccessors: true
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
              .project(target: "NetworkService", path: .relativeToRoot("Projects/Core/Network")),
              .project(target: "LocalStorage", path: .relativeToRoot("Projects/Core/LocalStorage"))
            ]
        )
    ]
)
