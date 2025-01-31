import ProjectDescription

let project = Project(
    name: "BaseFeature",
    options: .options(
      disableBundleAccessors: true,
      disableSynthesizedResourceAccessors: true
    ),
    settings: .settings(base: [
      "SWIFT_VERSION": "5.7"
    ]),
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
              .project(target: "AgencyInterface", path: .relativeToRoot("Projects/Domain/Agency")),
              .project(target: "LedgerInterface", path: .relativeToRoot("Projects/Domain/Ledger")),
              .project(target: "UserInterface", path: .relativeToRoot("Projects/Domain/User")),
              .project(target: "AuthInterface", path: .relativeToRoot("Projects/Domain/Auth"))
            ]
        )
    ]
)
