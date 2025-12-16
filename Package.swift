// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "voicebox-swift",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "VoiceBox",
            targets: ["VoiceBox"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/supabase/supabase-swift.git", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "VoiceBox",
            dependencies: [
                .product(name: "Supabase", package: "supabase-swift")
            ],
            path: "Sources/VoiceBox"
        ),
        .testTarget(
            name: "VoiceBoxTests",
            dependencies: ["VoiceBox"]
        )
    ]
)
