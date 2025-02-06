import ProjectDescription

let project = Project(
  name: "Repository",
  options: .options(
    disableBundleAccessors: true,
    disableSynthesizedResourceAccessors: true
  ),
  settings: .settings(base: [
    "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
    "OTHER_LDFLAGS": "-ObjC",
    "SWIFT_VERSION": "5.7"
  ]),
  targets: [
    Target(
      name: "Repository",
      platform: .iOS,
      product: .framework,
      bundleId: "com.framework.moneymong.Repository",
      deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
      sources: ["Sources/**"],
      dependencies: [
        .project(target: "BaseDomain", path: .relativeToRoot("Projects/Domain/BaseDomain")),
        .project(target: "MMNetworkInterface", path: .relativeToRoot("Projects/Core/MMNetwork")),
        .project(target: "MMStorageInterface", path: .relativeToRoot("Projects/Core/MMStorage"))
      ],
      launchArguments: [
        LaunchArgument(name: "IDEPreferLogStreaming=YES", isEnabled: true),
        LaunchArgument(name: "-FIRDebugEnabled", isEnabled: true)
      ]
    ),
    Target(
        name: "RepositoryTests",
        platform: .iOS,
        product: .unitTests,
        bundleId: "com.framework.moneymong.RepositoryTests",
        deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
        sources: ["Tests/**"],
        dependencies: [
            .target(name: "Repository"),
            .target(name: "RepositoryTesting")
        ]
    ),
    Target(
        name: "RepositoryTesting",
        platform: .iOS,
        product: .staticLibrary,
        bundleId: "com.framework.moneymong.RepositoryTesting",
        deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
        sources: ["Testing/**"],
        dependencies: [
            .target(name: "Repository")
        ]
    )
  ]
)
