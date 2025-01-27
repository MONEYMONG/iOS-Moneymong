import ProjectDescription

let project = Project(
    name: "LedgerFeature",
    options: .options(
      disableBundleAccessors: true,
      disableSynthesizedResourceAccessors: true
    ),
    settings: .settings(
        base: .init()
        .swiftVersion("5.7")
    ),
    targets: [
        Target(
            name: "LedgerFeature",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.LedgerFeature",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Sources/**"],
            dependencies: [
              .target(name: "LedgerFeatureInterface")
            ]
        ),
        Target(
            name: "LedgerFeatureInterface",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.LedgerFeatureInterface",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Interface/**"],
            dependencies: [
              .project(target: "BaseFeature", path: .relativeToRoot("Projects/Feature/Base")),
              .project(target: "LedgerInterface", path: .relativeToRoot("Projects/Domain/Ledger")),
              .project(target: "AgencyInterface", path: .relativeToRoot("Projects/Domain/Agency"))
            ]
        ),
        Target(
            name: "LedgerFeatureTesting",
            platform: .iOS,
            product: .staticLibrary,
            bundleId: "com.framework.moneymong.LedgerFeatureTesting",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Testing/**"],
            dependencies: [
                .target(name: "LedgerFeatureInterface")
            ]
        ),
        Target(
            name: "LedgerFeatureTests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "com.framework.moneymong.LedgerFeatureTests",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "LedgerFeature"),
                .target(name: "LedgerFeatureTesting")
            ]
        ),
        Target(
            name: "LedgerFeatureDemo",
            platform: .iOS,
            product: .app,
            bundleId: "com.framework.moneymong.LedgerFeatureDemo",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            infoPlist: .extendingDefault(with: [
              "NSCameraUsageDescription": "머니몽의 장부 내역 등록을 위해 카메라 및 사진에 접근하도록 허용합니다.",
              "NSPhotoLibraryUsageDescription": "머니몽의 장부 내역 등록을 위해 카메라 및 사진에 접근하도록 허용합니다.",
              "UIUserInterfaceStyle": "Light",
              "CFBundleShortVersionString": "1.0",
              "CFBundleVersion": "1",
              "UILaunchStoryboardName": "LaunchScreen",
              "UIApplicationSceneManifest" : [
                "UIApplicationSupportsMultipleScenes":true,
                "UISceneConfigurations":[
                  "UIWindowSceneSessionRoleApplication":[
                    [
                      "UISceneConfigurationName":"Default Configuration",
                      "UISceneDelegateClassName":"$(PRODUCT_MODULE_NAME).SceneDelegate"
                    ]
                  ]
                ]
              ],
              "NSLocalNetworkUsageDescription": "Network usage required for debugging purposes",
              "NSBonjourServices": ["_pulse._tcp"]
            ]),
            sources: ["Demo/Sources/**"],
            resources: ["Demo/Resources/**"],
            dependencies: [
                .target(name: "LedgerFeature"),
                .target(name: "LedgerFeatureTesting")
            ]
        )
    ]
)
