import ProjectDescription

let appNameAttribute: Template.Attribute = .required("name")

let appTemplate = Template(
    description: "Custom Module Template",
    attributes: [
        appNameAttribute
    ],
    items: [
        .file(
            path: "Project.swift",
            templatePath: "Project.stencil"
        ),
        .string(
            path: "Sources/Dummy.swift",
            contents: "// Dummy"
        ),
        .directory(
          path: "Resources",
          sourcePath: "Assets.xcassets"
        ),
        .file(
            path: "Sources/AppDelegate.swift",
            templatePath: "AppDelegate.stencil"
        ),
        .file(
            path: "Sources/SceneDelegate.swift",
            templatePath: "SceneDelegate.stencil"
        ),
        .file(
            path: "Sources/\(appNameAttribute)ViewController.swift",
            templatePath: "ViewController.stencil"
        ),
        .file(
            path: "Resources/LaunchScreen.storyboard",
            templatePath: "LaunchScreen.stencil"
        )
    ]
)
