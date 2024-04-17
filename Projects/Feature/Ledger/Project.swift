import ProjectDescription

let project = Project(
    name: "LedgerFeature",
    options: .options(
      disableBundleAccessors: true,
      disableSynthesizedResourceAccessors: true
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
              .project(target: "BaseFeature", path: .relativeToRoot("Projects/Feature/Base"))
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
                .target(name: "LedgerFeature")
            ]
        ),
        Target(
            name: "LedgerFeatureDemo",
            platform: .iOS,
            product: .app,
            bundleId: "com.framework.moneymong.LedgerFeatureDemo",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            infoPlist: .extendingDefault(with: [
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
              ]
            ]),
            sources: ["Demo/Sources/**"],
            resources: ["Demo/Resources/**"],
            dependencies: [
                .target(name: "LedgerFeature")
            ]
        )
    ]
)
