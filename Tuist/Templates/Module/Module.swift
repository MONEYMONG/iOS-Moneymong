import ProjectDescription

let moduleNameAttribute: Template.Attribute = .required("name")

let modulTemplate = Template(
    description: "Custom Module Template",
    attributes: [
        moduleNameAttribute
    ],
    items: [
        .file(
            path: "Project.swift",
            templatePath: "Project.stencil"
        ),
        .string(
            path: "Interface/Dummy.swift",
            contents: "// Dummy"
        ),
        .string(
            path: "Sources/Dummy.swift",
            contents: "// Dummy"
        ),
        .string(
            path: "Testing/Dummy.swift",
            contents: "// Dummy"
        ),
        .file(
            path: "Demo/Sources/AppDelegate.swift",
            templatePath: "AppDelegate.stencil"
        ),
        .file(
            path: "Demo/Sources/SceneDelegate.swift",
            templatePath: "SceneDelegate.stencil"
        ),
        .file(
            path: "Demo/Sources/LaunchScreen.storyboard",
            templatePath: "LaunchScreen.stencil"
        ),
        .file(
            path: "Tests/\(moduleNameAttribute)Tests.swift",
            templatePath: "Tests.stencil"
        )
    ]
)
