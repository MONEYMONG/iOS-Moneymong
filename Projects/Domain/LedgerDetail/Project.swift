import ProjectDescription

let project = Project(
    name: "LedgerDetailDomain",
    options: .options(
      disableBundleAccessors: true,
      disableSynthesizedResourceAccessors: true
    ),
    targets: [
        Target(
            name: "LedgerDetailDomain",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.LedgerDetailDomain",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Sources/**"],
            dependencies: [
              .project(target: "BaseDomain", path: .relativeToRoot("Projects/Domain/Base"))
            ]
        )
    ]
)
