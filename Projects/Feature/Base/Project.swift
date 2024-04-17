import ProjectDescription

let project = Project(
    name: "BaseFeature",
    options: .options(
      disableBundleAccessors: true,
      disableSynthesizedResourceAccessors: true
    ),
    targets: [
        Target(
            name: "BaseFeature",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.BaseFeature",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Sources/**"],
            dependencies: [
              .project(target: "DesignSystem", path: .relativeToRoot("Projects/Shared/DesignSystem")),
              .project(target: "ThirdPartyLips", path: .relativeToRoot("Projects/Shared/ThirdPartyLips")),
              .project(target: "Utils", path: .relativeToRoot("Projects/Shared/Utils"))
            ]
        )
    ]
)
