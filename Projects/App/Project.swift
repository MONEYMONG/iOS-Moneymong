import ProjectDescription

let project = Project(
  name: "Moneymong",
  options: .options(
    disableBundleAccessors: true,
    disableSynthesizedResourceAccessors: true
  ),
  targets: [
    Target(
      name: "Moneymong",
      platform: .iOS,
      product: .app,
      bundleId: "com.team.moneymong",
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
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: [
      ]
    )
  ]
)
