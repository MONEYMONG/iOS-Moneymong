import ProjectDescription

let project = Project(
    name: "CreateAgency",
    settings: .settings(
        base: .init()
        .swiftVersion("5.7")
    ),
    targets: [
        Target(
            name: "CreateAgency",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.CreateAgency",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Sources/**"],
            dependencies: [
              .target(name: "CreateAgencyInterface"),
              .project(target: "BaseFeature", path: .relativeToRoot("Projects/Feature/Base"))
            ]
        ),
        Target(
          name: "CreateAgencyInterface",
            platform: .iOS,
            product: .framework,
            bundleId: "com.framework.moneymong.CreateAgencyInterface",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Interface/**"],
            dependencies: [
              .project(target: "BaseFeatureInterface", path: .relativeToRoot("Projects/Feature/Base"))
            ]
        ),
        Target(
            name: "CreateAgencyTests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "com.framework.moneymong.CreateAgencyTests",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "CreateAgency"),
                .target(name: "CreateAgencyTesting")
            ]
        ),
        Target(
            name: "CreateAgencyTesting",
            platform: .iOS,
            product: .staticLibrary,
            bundleId: "com.framework.moneymong.CreateAgencyTesting",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            sources: ["Testing/**"],
            dependencies: [
                .target(name: "CreateAgencyInterface")
            ]
        ),
        Target(
            name: "CreateAgencyDemo",
            platform: .iOS,
            product: .app,
            bundleId: "com.framework.moneymong.CreateAgencyDemo",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            infoPlist: .extendingDefault(with: [
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
                .target(name: "CreateAgency"),
                .target(name: "CreateAgencyTesting")
            ]
        )
    ]
)
