import ProjectDescription

let project = Project(
    name: "AgencyDomain",
    options: .options(
      disableBundleAccessors: true,
      disableSynthesizedResourceAccessors: true
    ),
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
