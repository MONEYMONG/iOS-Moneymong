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
      bundleId: "com.yapp.moneymong",
      deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
      infoPlist: .extendingDefault(with: [
        "LSApplicationQueriesSchemes": ["kakaokompassauth", "kakaolink"],
        "CFBundleURLTypes": [
          [
            "CFBundleURLSchemes": ["kakao5412cf7a0e53089ab63f4e04b10622c5"],
            "CFBundleURLName": "com.salmal.app"
          ]
        ],
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
      entitlements: "Resources/App.entitlements",
      dependencies: [
        .project(target: "SignFeature", path: .relativeToRoot("Projects/Feature/Sign")),
        .project(target: "MainFeature", path: .relativeToRoot("Projects/Feature/Main"))
      ]
    )
  ]
)
