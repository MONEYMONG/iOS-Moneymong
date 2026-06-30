import ProjectDescription

let project = Project(
  name: "Moneymong",
  options: .options(
    disableBundleAccessors: true,
    disableSynthesizedResourceAccessors: true
  ),
  settings: .settings(
    base: .init()
      .marketingVersion("2.2.0")
      .swiftVersion("5.7")
      .currentProjectVersion("1")
      .appleGenericVersioningSystem()
  ),
  targets: [
    .init(
      name: "WidgetExtension",
      platform: .iOS,
      product: .appExtension,
      bundleId: "com.yapp.moneymong.WidgetExtension",
      deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
      infoPlist: .extendingDefault(with: [
        "CFBundleDisplayName": "$(PRODUCT_NAME)",
        "NSExtension": [
          "NSExtensionPointIdentifier": "com.apple.widgetkit-extension",
        ],
      ]),
      sources: "WidgetExtension/Sources/**",
      resources: "WidgetExtension/Resources/**",
      entitlements: "WidgetExtension/Resources/WidgetExtension.entitlements",
      dependencies: [
        .project(target: "DesignSystem", path: .relativeToRoot("Projects/Shared/DesignSystem"))
      ],
      settings: .settings(
        base: [
          "DEVELOPMENT_TEAM[sdk=iphoneos*]": "H5G7RFWFSQ",
          "CODE_SIGN_STYLE": "Manual"
        ],
        configurations: [
          .debug(name: "Debug", settings: [
            "CODE_SIGN_IDENTITY": "Apple Development: Nayeon Gu (3CMPGMMD7L)",
            "PROVISIONING_PROFILE_SPECIFIER": "match Development com.yapp.moneymong.WidgetExtension 1769511006"
          ]),
          .release(name: "Release", settings: [
            "CODE_SIGN_IDENTITY": "Apple Distribution: Nayeon Gu (H5G7RFWFSQ)",
            "PROVISIONING_PROFILE_SPECIFIER": "match AppStore com.yapp.moneymong.WidgetExtension 1769511389"
          ])
        ]
      )
    ),
    Target(
      name: "Moneymong",
      platform: .iOS,
      product: .app,
      bundleId: "com.yapp.moneymong",
      deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
      infoPlist: .extendingDefault(with: [
        "UIDesignRequiresCompatibility": true,
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
        .project(target: "MainFeature", path: .relativeToRoot("Projects/Feature/Main")),
        .target(name: "WidgetExtension"),
        .project(target: "User", path: .relativeToRoot("Projects/Domain/User")),
        .project(target: "Auth", path: .relativeToRoot("Projects/Domain/Auth")),
        .project(target: "Agency", path: .relativeToRoot("Projects/Domain/Agency")),
        .project(target: "Ledger", path: .relativeToRoot("Projects/Domain/Ledger")),
        .project(target: "Repository", path: .relativeToRoot("Projects/Core/Repository")),
        .project(target: "MMNetwork", path: .relativeToRoot("Projects/Core/MMNetwork")),
        .project(target: "MMStorage", path: .relativeToRoot("Projects/Core/MMStorage")),
        .project(target: "MyPageFeature", path: .relativeToRoot("Projects/Feature/MyPage")),
        .project(target: "AgencyFeature", path: .relativeToRoot("Projects/Feature/Agency")),
        .project(target: "LedgerFeature", path: .relativeToRoot("Projects/Feature/Ledger"))
      ],
      settings: .settings(
        base: [
          "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
          "OTHER_LDFLAGS": "-ObjC",
          "DEVELOPMENT_TEAM[sdk=iphoneos*]": "H5G7RFWFSQ",
          "CODE_SIGN_STYLE": "Manual"
        ],
        configurations: [
          .debug(name: "Debug", settings: [
            "CODE_SIGN_IDENTITY": "Apple Development: Nayeon Gu (3CMPGMMD7L)",
            "PROVISIONING_PROFILE_SPECIFIER": "match Development com.yapp.moneymong 1769511003"
          ]),
          .release(name: "Release", settings: [
            "CODE_SIGN_IDENTITY": "Apple Distribution: Nayeon Gu (H5G7RFWFSQ)",
            "PROVISIONING_PROFILE_SPECIFIER": "match AppStore com.yapp.moneymong 1769511386"
          ])
        ]
      ),
      launchArguments: [
        LaunchArgument(name: "IDEPreferLogStreaming=YES", isEnabled: true),
        LaunchArgument(name: "-FIRDebugEnabled", isEnabled: true)
      ]
    )
  ]
)
