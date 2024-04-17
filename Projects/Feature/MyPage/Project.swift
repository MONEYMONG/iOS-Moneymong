import ProjectDescription

let project = Project(
    name: "MyPageFeature",
    targets: [
        Target(
            name: "MyPageFeature",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.MyPageFeature",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Sources/**"],
            dependencies: [
              .project(target: "BaseFeature", path: .relativeToRoot("Projects/Feature/Base"))
            ]
        ),
        Target(
            name: "MyPageFeatureTests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "com.framework.moneymong.MyPageFeatureTests",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "MyPageFeature")
            ]
        ),
        Target(
            name: "MyPageFeatureDemo",
            platform: .iOS,
            product: .app,
            bundleId: "com.framework.moneymong.MyPageFeatureDemo",
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
                .target(name: "MyPageFeature")
            ]
        )
    ]
)
