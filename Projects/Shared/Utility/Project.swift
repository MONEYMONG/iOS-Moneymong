import ProjectDescription

let project = Project(
    name: "Utility",
    options: .options(
      disableBundleAccessors: true,
      disableSynthesizedResourceAccessors: true
    ),
    packages: [
      .remote(
        url: "https://github.com/firebase/firebase-ios-sdk",
        requirement: .upToNextMajor(from: "11.8.1")
      ),
    ],
    targets: [
        Target(
            name: "Utility",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.Utility",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Sources/**"],
            dependencies: [
              .package(product: "FirebaseAnalytics")
            ],
            settings: .settings(base: [
              "SWIFT_VERSION": "5.7"
            ])
        )
    ]
)
