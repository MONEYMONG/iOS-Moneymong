import ProjectDescription

let project = Project(
    name: "AgencyFeature",
    targets: [
        Target(
            name: "AgencyFeature",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.AgencyFeature",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Sources/**"],
            dependencies: [
                .target(name: "AgencyFeatureInterface")
            ]
        ),
        Target(
            name: "AgencyFeatureInterface",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.AgencyFeatureInterface",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Interface/**"],
            dependencies: [
            ]
        ),
        Target(
            name: "AgencyFeatureTests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "com.framework.moneymong.AgencyFeatureTests",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "AgencyFeature")
            ]
        ),
        Target(
            name: "AgencyFeatureDemo",
            platform: .iOS,
            product: .app,
            bundleId: "com.framework.moneymong.AgencyFeatureDemo",
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
                .target(name: "AgencyFeature")
            ]
        )
    ]
)
