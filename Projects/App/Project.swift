import ProjectDescription

let project = Project(
  name: "Moneymong",
  options: .options(
    disableBundleAccessors: true,
    disableSynthesizedResourceAccessors: true
  ),
  settings: .settings(
    base: .init()
      .marketingVersion("1.2.1")
      .swiftVersion("5.7")
      .currentProjectVersion("10")
      .appleGenericVersioningSystem(),
    configurations: [
      .debug(name: .debug, xcconfig: "Resources/APIKey.xcconfig"),
      .release(name: .release, xcconfig: "Resources/APIKey.xcconfig")
    ]
  ),
  targets: [
    Target(
      name: "Moneymong",
      platform: .iOS,
      product: .app,
      bundleId: "com.yapp.moneymong",
      deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
      infoPlist: .extendingDefault(with: [
        "CFBundleDisplayName": "머니몽",
        "UISupportedInterfaceOrientations": [
          "UIInterfaceOrientationPortrait"
        ],
        "NSCameraUsageDescription": "머니몽의 장부 내역 등록을 위해 카메라 및 사진에 접근하도록 허용합니다.",
        "NSPhotoLibraryUsageDescription": "머니몽의 장부 내역 등록을 위해 카메라 및 사진에 접근하도록 허용합니다.",
        "LSApplicationQueriesSchemes": ["kakaokompassauth", "kakaolink"],
        "CFBundleURLTypes": [
          [
            "CFBundleURLSchemes": ["kakao5412cf7a0e53089ab63f4e04b10622c5"],
            "CFBundleURLName": "com.yapp.moneymong"
          ]
        ],
        "UIUserInterfaceStyle": "Light",
        "NAVER_OCR_KEY": "$(NAVER_OCR_KEY)",
        "CFBundleShortVersionString": "$(MARKETING_VERSION)",
        "CFBundleVersion": "$(CURRENT_PROJECT_VERSION)",
        "UILaunchStoryboardName": "LaunchScreen",
        "UIApplicationSceneManifest": [
          "UIApplicationSupportsMultipleScenes": true,
          "UISceneConfigurations": [
            "UIWindowSceneSessionRoleApplication":[
              [
                "UISceneConfigurationName":"Default Configuration",
                "UISceneDelegateClassName":"$(PRODUCT_MODULE_NAME).SceneDelegate"
              ]
            ]
          ]
        ],
        "NSLocalNetworkUsageDescription": "Network usage required for debugging purposes",
        "NSBonjourServices": ["_pulse._tcp"],
        "ITSAppUsesNonExemptEncryption": "NO"
      ]),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      entitlements: "Resources/App.entitlements",
      dependencies: [
        .project(target: "SignFeature", path: .relativeToRoot("Projects/Feature/Sign")),
        .project(target: "MainFeature", path: .relativeToRoot("Projects/Feature/Main"))
      ],
      settings: .settings(
        base: .init()
          .cutomSetting()
      ),
      launchArguments: [
        LaunchArgument(name: "IDEPreferLogStreaming=YES", isEnabled: true),
        LaunchArgument(name: "-FIRDebugEnabled", isEnabled: true)
      ]
    )
  ]
)

extension Dictionary where Key == String, Value == ProjectDescription.SettingValue {
  func cutomSetting() -> SettingsDictionary {
    return merging([
      "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
      "OTHER_LDFLAGS": "-ObjC"
    ])
  }
}
