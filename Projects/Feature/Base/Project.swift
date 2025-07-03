import ProjectDescription

let project = Project(
    name: "BaseFeature",
    options: .options(
      disableBundleAccessors: true,
      disableSynthesizedResourceAccessors: true
    ),
    packages: [
      .remote(
        url: "https://github.com/Siwon-L/Feather",
        requirement: .upToNextMajor(from: "1.1.0")
      )
    ],
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
              .project(target: "AuthInterface", path: .relativeToRoot("Projects/Domain/Auth")),
              .package(product: "Feather")
            ]
        ),
        Target(
            name: "BaseFeatureTesting",
            platform: .iOS,
            product: .staticLibrary,
            bundleId: "com.framework.moneymong.BaseFeatureTesting",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Testing/**"],
            dependencies: [
              .project(target: "AgencyTesting", path: .relativeToRoot("Projects/Domain/Agency")),
              .project(target: "LedgerTesting", path: .relativeToRoot("Projects/Domain/Ledger")),
              .project(target: "UserTesting", path: .relativeToRoot("Projects/Domain/User")),
              .project(target: "AuthTesting", path: .relativeToRoot("Projects/Domain/Auth"))
            ]
        )
    ]
)
