
// swift-tools-version: 5.9
// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Ios_alinmapay",

    platforms: [
        .iOS(.v16)
    ],

    products: [
        .library(
            name: "Ios_alinmapay",
            targets: ["Ios_alinmapay"]
        )
    ],

    targets: [
        .target(
            name: "Ios_alinmapay",
            path: ".",
            exclude: [
                "SampleInApp",
                "PaymentSDK.xcodeproj",
                "PaymentWorkspace.xcworkspace",
                ".git"
            ],
            sources: [
                "PaymentSDK.swift",
                "Configuration",
                "Models",
                "Network",
                "Protocol",
                "Navigation",
                "Theme",
                "Utilities",
                "Views"
            ],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
