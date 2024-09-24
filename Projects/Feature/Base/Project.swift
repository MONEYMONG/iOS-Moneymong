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
              .project(target: "Core", path: .relativeToRoot("Projects/Core/Core"))
            ],
            settings: .settings(base: [
              "SWIFT_VERSION": "5.7"
            ])
        )
    ]
)
