import Foundation

/// Feature toggles for VoiceBox SDK
public struct Features {

    // MARK: - Presets

    /// All features enabled (default)
    public static let full = Features(
        tabs: .init(requests: true, roadmap: true, changelog: true),
        submissions: .init(enabled: true, images: true, anonymous: true, requireEmail: false),
        voting: .init(enabled: true, allowUnvote: true, showCounts: true),
        comments: .init(enabled: true, images: true, developerBadge: true),
        display: .init(statusBadges: true, userAvatars: true, announcement: true, searchBar: true, timestamps: true),
        notifications: .init(optInPrompt: true, onStatusChange: true)
    )

    /// Minimal features - requests and voting only
    public static let minimal = Features(
        tabs: .init(requests: true, roadmap: false, changelog: false),
        submissions: .init(enabled: true, images: false, anonymous: true, requireEmail: false),
        voting: .init(enabled: true, allowUnvote: true, showCounts: true),
        comments: .init(enabled: false, images: false, developerBadge: true),
        display: .init(statusBadges: true, userAvatars: false, announcement: false, searchBar: false, timestamps: true),
        notifications: .init(optInPrompt: false, onStatusChange: false)
    )

    /// Read-only mode - no submissions or voting
    public static let readOnly = Features(
        tabs: .init(requests: true, roadmap: true, changelog: true),
        submissions: .init(enabled: false, images: false, anonymous: false, requireEmail: false),
        voting: .init(enabled: false, allowUnvote: false, showCounts: true),
        comments: .init(enabled: false, images: false, developerBadge: true),
        display: .init(statusBadges: true, userAvatars: true, announcement: true, searchBar: true, timestamps: true),
        notifications: .init(optInPrompt: false, onStatusChange: false)
    )

    /// Voting only - no new submissions
    public static let votingOnly = Features(
        tabs: .init(requests: true, roadmap: false, changelog: false),
        submissions: .init(enabled: false, images: false, anonymous: false, requireEmail: false),
        voting: .init(enabled: true, allowUnvote: true, showCounts: true),
        comments: .init(enabled: true, images: false, developerBadge: true),
        display: .init(statusBadges: true, userAvatars: false, announcement: false, searchBar: true, timestamps: true),
        notifications: .init(optInPrompt: false, onStatusChange: false)
    )

    // MARK: - Feature Groups

    public var tabs: Tabs
    public var submissions: Submissions
    public var voting: Voting
    public var comments: Comments
    public var display: Display
    public var notifications: Notifications

    // MARK: - Tab Features

    public struct Tabs {
        public var requests: Bool
        public var roadmap: Bool
        public var changelog: Bool

        public init(requests: Bool = true, roadmap: Bool = true, changelog: Bool = true) {
            self.requests = requests
            self.roadmap = roadmap
            self.changelog = changelog
        }
    }

    // MARK: - Submission Features

    public struct Submissions {
        public var enabled: Bool
        public var images: Bool
        public var anonymous: Bool
        public var requireEmail: Bool

        public init(enabled: Bool = true, images: Bool = true, anonymous: Bool = true, requireEmail: Bool = false) {
            self.enabled = enabled
            self.images = images
            self.anonymous = anonymous
            self.requireEmail = requireEmail
        }
    }

    // MARK: - Voting Features

    public struct Voting {
        public var enabled: Bool
        public var allowUnvote: Bool
        public var showCounts: Bool

        public init(enabled: Bool = true, allowUnvote: Bool = true, showCounts: Bool = true) {
            self.enabled = enabled
            self.allowUnvote = allowUnvote
            self.showCounts = showCounts
        }
    }

    // MARK: - Comment Features

    public struct Comments {
        public var enabled: Bool
        public var images: Bool
        public var developerBadge: Bool

        public init(enabled: Bool = true, images: Bool = true, developerBadge: Bool = true) {
            self.enabled = enabled
            self.images = images
            self.developerBadge = developerBadge
        }
    }

    // MARK: - Display Features

    public struct Display {
        public var statusBadges: Bool
        public var userAvatars: Bool
        public var announcement: Bool
        public var searchBar: Bool
        public var timestamps: Bool

        public init(statusBadges: Bool = true, userAvatars: Bool = true, announcement: Bool = true, searchBar: Bool = true, timestamps: Bool = true) {
            self.statusBadges = statusBadges
            self.userAvatars = userAvatars
            self.announcement = announcement
            self.searchBar = searchBar
            self.timestamps = timestamps
        }
    }

    // MARK: - Notification Features

    public struct Notifications {
        public var optInPrompt: Bool
        public var onStatusChange: Bool

        public init(optInPrompt: Bool = true, onStatusChange: Bool = true) {
            self.optInPrompt = optInPrompt
            self.onStatusChange = onStatusChange
        }
    }

    // MARK: - Convenience Methods

    /// Disable multiple features at once
    public mutating func disable(_ features: FeatureFlag...) {
        for feature in features {
            setFeature(feature, enabled: false)
        }
    }

    /// Enable multiple features at once
    public mutating func enable(_ features: FeatureFlag...) {
        for feature in features {
            setFeature(feature, enabled: true)
        }
    }

    private mutating func setFeature(_ feature: FeatureFlag, enabled: Bool) {
        switch feature {
        case .requestsTab: tabs.requests = enabled
        case .roadmapTab: tabs.roadmap = enabled
        case .changelogTab: tabs.changelog = enabled
        case .submissions: submissions.enabled = enabled
        case .images: submissions.images = enabled; comments.images = enabled
        case .voting: voting.enabled = enabled
        case .comments: comments.enabled = enabled
        case .statusBadges: display.statusBadges = enabled
        case .announcement: display.announcement = enabled
        case .searchBar: display.searchBar = enabled
        }
    }
}

// MARK: - Feature Flags

public enum FeatureFlag {
    case requestsTab
    case roadmapTab
    case changelogTab
    case submissions
    case images
    case voting
    case comments
    case statusBadges
    case announcement
    case searchBar
}
