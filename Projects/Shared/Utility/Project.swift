import ProjectDescription

let project = Project(
    name: "Utility",
    options: .options(
      disableBundleAccessors: true,
      disableSynthesizedResourceAccessors: true
    ),
    targets: [
        Target(
            name: "Utility",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.Utility",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Sources/**"],
            dependencies: [
            ],
            settings: .settings(base: [
              "SWIFT_VERSION": "5.7"
            ])
        )
    ]
)
