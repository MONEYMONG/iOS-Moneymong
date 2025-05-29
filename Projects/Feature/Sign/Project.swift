import ProjectDescription

let project = Project(
  name: "SignFeature",
  options: .options(
    disableBundleAccessors: true,
    disableSynthesizedResourceAccessors: true
  ),
  targets: [
    Target(
      name: "SignFeature",
      platform: .iOS,
      product: .framework,
      bundleId: "com.framework.moneymong.SignFeature",
      deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
      infoPlist: .extendingDefault(with: [
        "LSApplicationQueriesSchemes": ["kakaokompassauth", "kakaolink"],
        "CFBundleURLTypes": [
          [
            "CFBundleURLSchemes": ["kakao5412cf7a0e53089ab63f4e04b10622c5"],
            "CFBundleURLName": "com.salmal.app"
          ]
        ],
      ]),
      sources: ["Sources/**"],
      dependencies: [
        .project(target: "AgencyFeatureInterface", path: .relativeToRoot("Projects/Feature/Agency")),
        .target(name: "SignFeatureInterface")
      ],
      settings: .settings(base: [
        "SWIFT_VERSION": "5.7"
      ])
    ),
    Target(
        name: "SignFeatureInterface",
        platform: .iOS,
        product: .framework,
        bundleId: "com.framework.moneymong.SignFeatureInterface",
        deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
        sources: ["Interface/**"],
        dependencies: [
          .project(target: "BaseFeature", path: .relativeToRoot("Projects/Feature/Base"))
        ]
    ),
    Target(
        name: "SignFeatureTesting",
        platform: .iOS,
        product: .staticLibrary,
        bundleId: "com.framework.moneymong.SignFeatureTesting",
        deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
        sources: ["Testing/**"],
        dependencies: [
            .target(name: "SignFeatureInterface")
        ]
    ),
    Target(
      name: "SignFeatureTests",
      platform: .iOS,
      product: .unitTests,
      bundleId: "com.framework.moneymong.SignFeatureTests",
      deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
      sources: ["Tests/**"],
      dependencies: [
        .target(name: "SignFeature"),
        .target(name: "SignFeatureTesting")
      ],
      launchArguments: [
        LaunchArgument(name: "IDEPreferLogStreaming=YES", isEnabled: true),
        LaunchArgument(name: "-FIRDebugEnabled", isEnabled: true),
      ]
    ),
    Target(
      name: "SignFeatureDemo",
      platform: .iOS,
      product: .app,
      bundleId: "com.framework.moneymong.SignFeatureDemo",
      deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
      infoPlist: .extendingDefault(with: [
        "QueriedURLSchemes": [
          "kakaokompappauth",
          "kakaolink"
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
        ],
        "NSLocalNetworkUsageDescription": "Network usage required for debugging purposes",
        "NSBonjourServices": ["_pulse._tcp"]
      ]),
      sources: ["Demo/Sources/**"],
      resources: ["Demo/Resources/**"],
      dependencies: [
        .target(name: "SignFeature"),
        .target(name: "SignFeatureTesting"),
        .project(target: "BaseFeatureTesting", path: .relativeToRoot("Projects/Feature/Base"))
      ]
    )
  ]
)
