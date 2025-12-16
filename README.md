# VoiceBox Swift SDK

In-app feedback, feature voting, roadmaps, and changelogs for iOS and macOS apps.

## Installation

Add VoiceBox using Swift Package Manager:

**Xcode:** File → Add Package Dependencies → Enter:
```
https://github.com/jacobWeeces/Voicebox-Swift-SDK.git
```

**Package.swift:**
```swift
dependencies: [
    .package(url: "https://github.com/jacobWeeces/Voicebox-Swift-SDK.git", from: "1.0.0")
]
```

## Requirements

- iOS 16.0+ / macOS 13.0+
- Swift 5.9+
- Xcode 15+

## Quick Start

```swift
import SwiftUI
import VoiceBox

@main
struct MyApp: App {
    init() {
        VoiceBox.configure(apiKey: "your-api-key")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

Show the feedback view:

```swift
struct ContentView: View {
    @State private var showFeedback = false

    var body: some View {
        Button("Give Feedback") {
            showFeedback = true
        }
        .sheet(isPresented: $showFeedback) {
            VoiceBox.FeedbackView()
        }
    }
}
```

## Views

| View | Description |
|------|-------------|
| `VoiceBox.FeedbackView()` | Full tabbed experience (Requests, Roadmap, Changelog) |
| `VoiceBox.RequestsView()` | Feature requests list only |
| `VoiceBox.RoadmapView()` | Public roadmap only |
| `VoiceBox.ChangelogView()` | Release notes only |
| `VoiceBox.NewRequestView()` | Feedback submission form |
| `VoiceBox.FeedbackButton()` | Button that opens feedback form |

### Feedback Button Styles

```swift
VoiceBox.FeedbackButton()                    // Standard
VoiceBox.FeedbackButton(style: .pill)        // Pill-shaped
VoiceBox.FeedbackButton(style: .floating)    // FAB style
VoiceBox.FeedbackButton(style: .text)        // Text only

// Custom label
VoiceBox.FeedbackButton {
    Label("Share an idea", systemImage: "lightbulb")
}
```

### UIKit

```swift
let feedbackVC = VoiceBox.viewController()
present(feedbackVC, animated: true)
```

## Configuration

### User Information

```swift
VoiceBox.configure(apiKey: "your-api-key") { config in
    config.user.email = "user@example.com"
    config.user.name = "John Doe"
}
```

### Feature Toggles

Use presets or customize individually:

```swift
VoiceBox.configure(apiKey: "your-api-key") { config in
    config.features = .full        // Everything enabled (default)
    config.features = .minimal     // Requests + voting only
    config.features = .readOnly    // View only, no submissions
    config.features = .votingOnly  // No new requests, just voting
}
```

| Preset | Requests | Roadmap | Changelog | Voting | Comments | Submissions |
|--------|:--------:|:-------:|:---------:|:------:|:--------:|:-----------:|
| `.full` | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| `.minimal` | ✓ | ✗ | ✗ | ✓ | ✗ | ✓ |
| `.readOnly` | ✓ | ✓ | ✓ | ✗ | ✗ | ✗ |
| `.votingOnly` | ✓ | ✗ | ✗ | ✓ | ✓ | ✗ |

Granular control:

```swift
config.features.tabs.changelog = false
config.features.submissions.images = true
config.features.voting.showCounts = true
config.features.comments.developerBadge = true
```

### Theming

```swift
VoiceBox.configure(apiKey: "your-api-key") { config in
    config.theme.accentColor = .purple
    config.theme.cardStyle = .rounded  // .rounded, .flat, .bordered

    // Status colors
    config.theme.statusColors.planned = .blue
    config.theme.statusColors.inProgress = .purple
    config.theme.statusColors.completed = .green
}
```

### Localization

```swift
VoiceBox.configure(apiKey: "your-api-key") { config in
    config.localization.requestsTab = "Ideas"
    config.localization.submitButton = "Share Idea"
    config.localization.voteButton = "Upvote"
}
```

## Announcements

Display announcements from your dashboard:

```swift
ContentView()
    .voiceBoxAnnouncement()
```

Configure behavior:

```swift
ContentView()
    .voiceBoxAnnouncement { config in
        config.position = .top                           // .top or .bottom
        config.isDismissible = true
        config.dismissBehavior = .untilNewAnnouncement   // .sessionOnly, .forever, .timed(hours: 24)
    }
```

Or place manually:

```swift
VStack {
    VoiceBox.AnnouncementBanner()
    // Your content
}
```

## User Segmentation

Track user metadata for filtering feedback in your dashboard:

```swift
VoiceBox.configure(apiKey: "your-api-key") { config in
    config.user.email = "user@example.com"
    config.user.name = "John Doe"

    // Payment tier (for revenue-weighted prioritization)
    config.user.payment = .monthly(9.99)  // .none, .weekly, .monthly, .yearly, .lifetime

    // Custom metadata
    config.user.metadata = [
        "plan": "pro",
        "company": "Acme Inc"
    ]
}
```

## Troubleshooting

**"VoiceBox has not been configured"**
Call `VoiceBox.configure(apiKey:)` in your app's `init()` before showing any views.

**Views not loading**
Check your API key is correct and device has network connectivity.

**Theme not applying**
Set theme in the configuration closure, not after:
```swift
VoiceBox.configure(apiKey: "...") { config in
    config.theme.accentColor = .purple  // ✓ Correct
}
```

**Build errors with Supabase**
Clean build folder (⇧⌘K) and reset package caches (File → Packages → Reset Package Caches).

## License

MIT License - see [LICENSE](LICENSE) for details.
