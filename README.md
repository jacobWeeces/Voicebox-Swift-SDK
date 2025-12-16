# VoiceBox Swift SDK

The VoiceBox Swift SDK enables in-app feature requests, voting, roadmaps, and changelogs for iOS and macOS applications. Collect valuable feedback from your users and let them vote on features they want to see.

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
  - [Basic Setup](#basic-setup)
  - [User Information](#user-information)
  - [Feature Toggles](#feature-toggles)
  - [Theming](#theming)
  - [Localization](#localization)
- [Views](#views)
  - [SwiftUI Views](#swiftui-views)
  - [UIKit Integration](#uikit-integration)
- [Announcements](#announcements)
  - [Quick Start](#quick-start-1)
  - [Configuration Options](#configuration-options)
  - [Custom Placement](#custom-placement)
  - [Manual Refresh](#manual-refresh)
- [User Segmentation](#user-segmentation)
- [API Reference](#api-reference)
- [Troubleshooting](#troubleshooting)

---

## Features

- **Feature Requests**: Let users submit ideas and suggestions
- **Voting System**: Users can upvote requests they care about
- **Roadmap View**: Show what's planned, in progress, and completed
- **Changelog View**: Keep users informed about updates
- **Developer Badge**: Responses from your team are highlighted
- **Announcements**: Communicate directly with your users
- **Image Attachments**: Support for images in requests and comments
- **User Segmentation**: Filter feedback by payment tier, email, or custom metadata
- **Fully Customizable**: Themes, localization, and feature toggles

---

## Requirements

| Platform | Minimum Version |
|----------|-----------------|
| iOS      | 16.0+           |
| macOS    | 13.0+           |
| Swift    | 5.9+            |
| Xcode    | 15+             |

---

## Installation

### Swift Package Manager (Recommended)

Add VoiceBox to your project using Xcode:

1. Go to **File → Add Package Dependencies...**
2. Enter the repository URL:
   ```
   https://github.com/jacobWeeces/voicebox-swift
   ```
3. Select version `1.0.0` or later
4. Click **Add Package**

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/jacobWeeces/voicebox-swift", from: "1.0.0")
]
```

Then add `VoiceBox` to your target's dependencies:

```swift
.target(
    name: "YourApp",
    dependencies: ["VoiceBox"]
)
```

---

## Quick Start

### 1. Configure VoiceBox

In your app's initialization (e.g., `@main` App struct or `AppDelegate`):

```swift
import VoiceBox

@main
struct MyApp: App {
    init() {
        VoiceBox.configure(apiKey: "vb_live_xxxxx")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### 2. Show the Feedback View

```swift
import SwiftUI
import VoiceBox

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

That's it! Your users can now submit feedback, vote on features, and view your roadmap.

---

## Configuration

### Basic Setup

The simplest configuration only requires your API key:

```swift
VoiceBox.configure(apiKey: "vb_live_xxxxx")
```

Get your API key from the [VoiceBox Dashboard](https://voicebox.io/dashboard).

### User Information

Provide user context for better segmentation and notifications:

```swift
VoiceBox.configure(apiKey: "vb_live_xxxxx") { config in
    // User identification (for notifications and segmentation)
    config.user.email = "user@example.com"
    config.user.name = "John Doe"

    // Payment information (for segmentation)
    config.user.payment = .monthly(9.99)

    // Custom metadata (for filtering in dashboard)
    config.user.metadata = [
        "plan": "pro",
        "company": "Acme Inc",
        "referral": "twitter"
    ]
}
```

#### Payment Options

```swift
config.user.payment = .none              // Free users
config.user.payment = .weekly(2.99)      // Weekly subscription
config.user.payment = .monthly(9.99)     // Monthly subscription
config.user.payment = .yearly(79.99)     // Yearly subscription
config.user.payment = .lifetime(199.99)  // One-time purchase
```

---

### Feature Toggles

Control which features are available to your users.

#### Presets

Start with a preset and customize as needed:

```swift
VoiceBox.configure(apiKey: "vb_live_xxxxx") { config in
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

#### Granular Control

Customize individual features:

```swift
VoiceBox.configure(apiKey: "vb_live_xxxxx") { config in
    // Start with a preset
    config.features = .full

    // Customize tabs
    config.features.tabs.requests = true
    config.features.tabs.roadmap = true
    config.features.tabs.changelog = false  // Hide changelog

    // Customize submissions
    config.features.submissions.enabled = true
    config.features.submissions.images = true       // Allow image attachments
    config.features.submissions.anonymous = true    // Allow anonymous submissions
    config.features.submissions.requireEmail = false // Email is optional

    // Customize voting
    config.features.voting.enabled = true
    config.features.voting.allowUnvote = true  // Users can remove their vote
    config.features.voting.showCounts = true   // Show vote counts

    // Customize comments
    config.features.comments.enabled = true
    config.features.comments.images = true         // Allow images in comments
    config.features.comments.developerBadge = true // Show "Developer" badge

    // Customize display
    config.features.display.statusBadges = true   // Show status (Open, Planned, etc.)
    config.features.display.userAvatars = true    // Show user avatars
    config.features.display.announcement = true   // Show developer announcements
    config.features.display.searchBar = true      // Show search functionality
    config.features.display.timestamps = true     // Show "2 days ago"

    // Customize notifications
    config.features.notifications.optInPrompt = true    // Ask for notification permission
    config.features.notifications.onStatusChange = true // Notify when status changes
}
```

#### Convenience Methods

Quickly enable or disable multiple features:

```swift
config.features.disable(.comments, .images, .roadmapTab)
config.features.enable(.voting, .statusBadges)
```

Available feature flags:
- `.requestsTab`, `.roadmapTab`, `.changelogTab`
- `.submissions`, `.images`, `.voting`, `.comments`
- `.statusBadges`, `.announcement`, `.searchBar`

---

### Theming

Customize the visual appearance to match your app:

```swift
VoiceBox.configure(apiKey: "vb_live_xxxxx") { config in
    // Colors
    config.theme.accentColor = .purple
    config.theme.backgroundColor = Color(.systemBackground)
    config.theme.secondaryBackgroundColor = Color(.secondarySystemBackground)
    config.theme.primaryTextColor = Color(.label)
    config.theme.secondaryTextColor = Color(.secondaryLabel)

    // Card style
    config.theme.cardStyle = .rounded   // Default - rounded corners with shadow
    config.theme.cardStyle = .flat      // No corners, no shadow
    config.theme.cardStyle = .bordered  // Border, no shadow

    // Status badge colors
    config.theme.statusColors.open = .gray
    config.theme.statusColors.underReview = .orange
    config.theme.statusColors.planned = .blue
    config.theme.statusColors.inProgress = .purple
    config.theme.statusColors.completed = .green
    config.theme.statusColors.declined = .red

    // Typography
    config.theme.titleFont = .headline
    config.theme.bodyFont = .body
    config.theme.captionFont = .caption

    // Spacing
    config.theme.padding = 16
    config.theme.spacing = 12
}
```

#### Card Styles

| Style | Corner Radius | Shadow | Border |
|-------|:-------------:|:------:|:------:|
| `.rounded` | 12pt | Yes | No |
| `.flat` | 0 | No | No |
| `.bordered` | 8pt | No | Yes |

---

### Localization

Customize all UI strings for your language or tone:

```swift
VoiceBox.configure(apiKey: "vb_live_xxxxx") { config in
    // Navigation
    config.localization.requestsTab = "Ideas"
    config.localization.roadmapTab = "Coming Soon"
    config.localization.changelogTab = "What's New"

    // Buttons
    config.localization.submitButton = "Share Idea"
    config.localization.voteButton = "Upvote"
    config.localization.votedButton = "Upvoted"
    config.localization.cancelButton = "Cancel"
    config.localization.commentButton = "Reply"
    config.localization.sendButton = "Send"

    // Placeholders
    config.localization.titlePlaceholder = "What's your idea?"
    config.localization.descriptionPlaceholder = "Tell us more..."
    config.localization.commentPlaceholder = "Add your thoughts..."
    config.localization.searchPlaceholder = "Search ideas..."
    config.localization.emailPlaceholder = "Email for updates"

    // Labels
    config.localization.newRequestLabel = "New Idea"
    config.localization.announcementLabel = "Message from the Team"
    config.localization.developerBadge = "Team"

    // Status labels
    config.localization.statusOpen = "New"
    config.localization.statusUnderReview = "Reviewing"
    config.localization.statusPlanned = "Planned"
    config.localization.statusInProgress = "Building"
    config.localization.statusCompleted = "Shipped"
    config.localization.statusDeclined = "Not Now"

    // Empty states
    config.localization.noRequestsTitle = "No ideas yet"
    config.localization.noRequestsMessage = "Be the first to share an idea!"
    config.localization.noRoadmapTitle = "Roadmap coming soon"
    config.localization.noChangelogTitle = "No updates yet"

    // Success messages
    config.localization.requestSubmitted = "Thanks for sharing!"
    config.localization.commentAdded = "Reply added"

    // Errors
    config.localization.errorTitle = "Oops!"
    config.localization.errorRetry = "Try Again"
}
```

---

## Views

### SwiftUI Views

#### Full Tabbed Experience

The main view with all three tabs (Requests, Roadmap, Changelog):

```swift
VoiceBox.FeedbackView()
```

#### Individual Views

Use individual views for more control:

```swift
// Feature requests list
VoiceBox.RequestsView()

// Public roadmap
VoiceBox.RoadmapView()

// Changelog/release notes
VoiceBox.ChangelogView()

// New feedback submission form
VoiceBox.NewRequestView()
```

#### Feedback Button

Add a button anywhere in your app to let users submit feedback:

```swift
// Standard button
VoiceBox.FeedbackButton()

// Pill-shaped button
VoiceBox.FeedbackButton(style: .pill)

// Floating action button (great for overlays)
VoiceBox.FeedbackButton(style: .floating)

// Text-only button
VoiceBox.FeedbackButton(style: .text)

// Custom label
VoiceBox.FeedbackButton {
    Label("Share an idea", systemImage: "lightbulb")
        .padding()
        .background(Color.orange)
        .foregroundColor(.white)
        .cornerRadius(8)
}
```

**Floating Action Button Example:**

```swift
struct ContentView: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // Your main content
            ScrollView {
                // ...
            }

            // Floating feedback button
            VoiceBox.FeedbackButton(style: .floating)
                .padding()
        }
    }
}
```

#### Presentation Examples

```swift
// Sheet presentation
struct ContentView: View {
    @State private var showFeedback = false

    var body: some View {
        Button("Feedback") {
            showFeedback = true
        }
        .sheet(isPresented: $showFeedback) {
            VoiceBox.FeedbackView()
        }
    }
}

// Full screen cover
.fullScreenCover(isPresented: $showFeedback) {
    NavigationStack {
        VoiceBox.FeedbackView()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { showFeedback = false }
                }
            }
    }
}

// Navigation destination
NavigationStack {
    List {
        NavigationLink("Feature Requests") {
            VoiceBox.RequestsView()
        }
        NavigationLink("Roadmap") {
            VoiceBox.RoadmapView()
        }
    }
}
```

### UIKit Integration

For UIKit apps or hybrid SwiftUI/UIKit apps:

```swift
import UIKit
import VoiceBox

class SettingsViewController: UIViewController {
    @IBAction func feedbackTapped(_ sender: Any) {
        let feedbackVC = VoiceBox.viewController()
        present(feedbackVC, animated: true)
    }
}
```

With a navigation controller:

```swift
let feedbackVC = VoiceBox.viewController()
let navController = UINavigationController(rootViewController: feedbackVC)
present(navController, animated: true)
```

---

## Announcements

Communicate directly with your users through announcement banners. Show important updates, new features, or time-sensitive messages right in your app.

### Quick Start

Add the announcement banner to your root view:

```swift
import SwiftUI
import VoiceBox

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .voiceBoxAnnouncement()
        }
    }
}
```

That's it! When you create an announcement in the VoiceBox dashboard, it will automatically appear in your app.

### Configuration Options

Customize the banner's behavior and appearance:

```swift
ContentView()
    .voiceBoxAnnouncement { config in
        // Dismiss behavior
        config.dismissBehavior = .untilNewAnnouncement

        // Interaction
        config.isDismissible = true
        config.isTappable = true

        // Position
        config.position = .top

        // Custom header label
        config.headerLabel = "Important Update"
    }
```

#### Dismiss Behavior

Control how long a dismissed announcement stays hidden:

| Option | Description |
|--------|-------------|
| `.sessionOnly` | Reappears on app restart |
| `.untilNewAnnouncement` | Hidden until a different announcement is active (default) |
| `.forever` | This specific announcement never shows again |
| `.timed(hours: 24)` | Reappears after the specified number of hours |

**Examples:**

```swift
// Banner reappears every time the app launches
config.dismissBehavior = .sessionOnly

// User never sees this announcement again
config.dismissBehavior = .forever

// Banner reappears after 24 hours
config.dismissBehavior = .timed(hours: 24)
```

#### Interaction Options

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `isDismissible` | `Bool` | `true` | Whether the user can dismiss the banner |
| `isTappable` | `Bool` | `true` | Whether tapping expands the banner to show full content |
| `position` | `Position` | `.top` | Where the banner appears (`.top` or `.bottom`) |
| `headerLabel` | `String?` | `nil` | Custom label for the banner header (uses global localization if `nil`) |

**Examples:**

```swift
// Non-dismissible announcement (user must see it)
config.isDismissible = false

// Show full content without needing to tap
config.isTappable = false

// Position at bottom of screen
config.position = .bottom
```

#### Advanced Options

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `animationDuration` | `Double` | `0.3` | Duration of expand/collapse animations in seconds |
| `collapsedBodyLines` | `Int?` | `2` | Number of lines to show when collapsed. `nil` shows full body |

```swift
// Show more content before requiring expansion
config.collapsedBodyLines = 4

// Faster animations
config.animationDuration = 0.2
```

### Custom Placement

For more control over banner placement, use `VoiceBox.AnnouncementBanner()` directly:

```swift
struct CustomView: View {
    var body: some View {
        VStack {
            // Your header
            HeaderView()

            // Announcement banner placed exactly where you want it
            VoiceBox.AnnouncementBanner { config in
                config.position = .top
                config.dismissBehavior = .forever
            }

            // Your content
            ContentScrollView()
        }
    }
}
```

This gives you pixel-perfect control over where announcements appear in your UI hierarchy.

### Manual Refresh

Announcements refresh automatically when your app becomes active, but you can also refresh manually:

```swift
Button("Check for Updates") {
    Task {
        await VoiceBox.refreshAnnouncement()
    }
}
```

This is useful for:
- Refresh buttons in your UI
- Custom refresh logic based on user actions
- Testing announcements during development

---

## User Segmentation

VoiceBox allows you to segment feedback by user characteristics. This helps you prioritize requests from paying customers or specific user groups.

### Setting User Data

```swift
VoiceBox.configure(apiKey: "vb_live_xxxxx") { config in
    // Basic identification
    config.user.email = "user@example.com"
    config.user.name = "John Doe"

    // Payment tier (for revenue-weighted prioritization)
    config.user.payment = .yearly(79.99)

    // Custom metadata (for filtering)
    config.user.metadata = [
        "plan": "enterprise",
        "team_size": "50+",
        "industry": "saas",
        "beta_tester": "true"
    ]
}
```

### Dashboard Filtering

In the VoiceBox web dashboard, you can filter feedback by:
- **Payment tier**: See requests from paying users vs free users
- **Revenue impact**: Prioritize by total revenue from voters
- **Custom metadata**: Filter by any metadata key/value

---

## API Reference

### VoiceBox

| Method | Description |
|--------|-------------|
| `VoiceBox.configure(apiKey:configure:)` | Initialize VoiceBox with your API key |
| `VoiceBox.shared.isConfigured` | Check if VoiceBox is configured |
| `VoiceBox.FeedbackView()` | SwiftUI view with all tabs |
| `VoiceBox.RequestsView()` | SwiftUI view for requests only |
| `VoiceBox.RoadmapView()` | SwiftUI view for roadmap only |
| `VoiceBox.ChangelogView()` | SwiftUI view for changelog only |
| `VoiceBox.NewRequestView()` | SwiftUI view for submitting new feedback |
| `VoiceBox.FeedbackButton(style:)` | Button that opens feedback submission form |
| `VoiceBox.AnnouncementBanner(configure:)` | SwiftUI announcement banner view |
| `VoiceBox.refreshAnnouncement()` | Manually refresh announcements from server |
| `VoiceBox.viewController()` | UIKit view controller |

### View Modifiers

| Method | Description |
|--------|-------------|
| `.voiceBoxAnnouncement(configure:)` | Add announcement banner overlay to any view |

### Configuration

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `apiKey` | `String` | Required | Your VoiceBox API key |
| `user` | `UserConfiguration` | Empty | User identification |
| `features` | `Features` | `.full` | Feature toggles |
| `theme` | `Theme` | System | Visual customization |
| `localization` | `Localization` | English | UI strings |

### UserConfiguration

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `email` | `String?` | `nil` | User's email for notifications |
| `name` | `String?` | `nil` | User's display name |
| `payment` | `Payment` | `.none` | Payment information |
| `metadata` | `[String: String]` | `[:]` | Custom attributes |

### FeedbackStatus

| Case | Raw Value | Description |
|------|-----------|-------------|
| `.open` | `"open"` | New, unreviewed request |
| `.underReview` | `"under_review"` | Being considered |
| `.planned` | `"planned"` | Approved for development |
| `.inProgress` | `"in_progress"` | Currently being built |
| `.completed` | `"completed"` | Shipped and available |
| `.declined` | `"declined"` | Not planned |

---

## Troubleshooting

### "VoiceBox has not been configured"

Make sure you call `VoiceBox.configure(apiKey:)` before showing any VoiceBox views. The best place is in your app's `init()` or `application(_:didFinishLaunchingWithOptions:)`.

```swift
@main
struct MyApp: App {
    init() {
        VoiceBox.configure(apiKey: "vb_live_xxxxx")
    }
    // ...
}
```

### Views not appearing

1. Ensure you have a valid API key from the dashboard
2. Check your network connection
3. Verify the project exists in your dashboard

### Votes/Comments not saving

1. Check that your API key is correct
2. Ensure the device has internet connectivity
3. Verify features aren't disabled (`config.features.voting.enabled = true`)

### Custom theme not applying

Make sure you set theme properties in the configuration closure:

```swift
VoiceBox.configure(apiKey: "vb_live_xxxxx") { config in
    config.theme.accentColor = .purple  // Correct
}

// Not:
// VoiceBox.shared.configuration?.theme.accentColor = .purple  // Won't work
```

### Build errors with Supabase

VoiceBox depends on the Supabase Swift SDK. If you encounter build errors:

1. Clean build folder: **Product → Clean Build Folder** (⇧⌘K)
2. Reset package caches: **File → Packages → Reset Package Caches**
3. Ensure you're using Xcode 15 or later

### "Invalid API key" or "Unauthorized"

1. Double-check your API key is copied correctly (no extra spaces)
2. Ensure you're using the correct key type:
   - `vb_live_xxxxx` for production
   - `vb_test_xxxxx` for development/testing
3. Verify your project is active in the dashboard

### Network request failed / Timeout errors

```swift
// If network issues persist:
// 1. Check device has internet connectivity
// 2. Verify no VPN/firewall blocking requests
// 3. Check status.voicebox.io for service status
```

### Images not uploading

1. Ensure image attachments are enabled:
   ```swift
   config.features.submissions.images = true
   config.features.comments.images = true
   ```
2. Check image size is under 10MB
3. Supported formats: JPEG, PNG, HEIC

### User data not syncing to dashboard

Make sure you're setting user info in the configuration:

```swift
VoiceBox.configure(apiKey: "vb_live_xxxxx") { config in
    config.user.email = currentUser.email  // Set from your auth
    config.user.name = currentUser.displayName
}
```

**Note:** User data is set once at configuration. To update user info after login:

```swift
// Re-configure when user signs in
func userDidSignIn(_ user: User) {
    VoiceBox.configure(apiKey: "vb_live_xxxxx") { config in
        config.user.email = user.email
        config.user.name = user.name
        config.user.payment = .monthly(user.subscriptionPrice)
    }
}
```

### Feedback list is empty

1. **New project?** Submit your first feedback to see it appear
2. **Status filter active?** Check if a status filter is hiding items
3. **Search active?** Clear the search field
4. **API key mismatch?** Ensure dashboard and app use the same project

### Dark mode / appearance issues

VoiceBox respects system appearance by default. To force a specific mode:

```swift
VoiceBox.FeedbackView()
    .preferredColorScheme(.dark)  // or .light
```

Or customize colors for both modes:

```swift
config.theme.backgroundColor = Color(.systemBackground)  // Adapts automatically
config.theme.primaryTextColor = Color(.label)  // Adapts automatically
```

### SwiftUI preview crashes

Previews may crash if VoiceBox isn't configured. Add configuration to your preview:

```swift
struct FeedbackButton_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackButton()
            .onAppear {
                VoiceBox.configure(apiKey: "vb_test_preview")
            }
    }
}
```

### UIKit presentation issues

If the view controller doesn't present correctly:

```swift
// Wrap in navigation controller for proper toolbar support
let feedbackVC = VoiceBox.viewController()
let navController = UINavigationController(rootViewController: feedbackVC)
navController.modalPresentationStyle = .pageSheet  // or .fullScreen
present(navController, animated: true)
```

### Memory warnings / performance

VoiceBox caches images efficiently, but for large feedback lists:

```swift
// Pagination is automatic - VoiceBox loads 20 items at a time
// If you experience issues, check for memory leaks in your own code
```

### Localization not working

Ensure you set localization strings in the configuration, not after:

```swift
VoiceBox.configure(apiKey: "vb_live_xxxxx") { config in
    config.localization.submitButton = "Enviar"  // ✅ Correct
}

// ❌ This won't work:
// VoiceBox.shared.configuration?.localization.submitButton = "Enviar"
```

### Still having issues?

1. **Enable debug logging** (coming soon)
2. **Check our status page**: [status.voicebox.io](https://status.voicebox.io)
3. **Search existing issues**: [GitHub Issues](https://github.com/jacobWeeces/voicebox-swift/issues)
4. **Contact support**: support@voicebox.io

---

## Support

- **Documentation**: [voicebox.io/docs](https://voicebox.io/docs)
- **Dashboard**: [voicebox.io/dashboard](https://voicebox.io/dashboard)
- **GitHub Issues**: [github.com/jacobWeeces/voicebox-swift/issues](https://github.com/jacobWeeces/voicebox-swift/issues)

---

## License

MIT License - see [LICENSE](LICENSE) for details.
