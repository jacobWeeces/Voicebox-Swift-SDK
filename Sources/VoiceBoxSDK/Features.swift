import Foundation

/// Feature toggles for VoiceBox SDK - fetched from server on init
public struct Features: Decodable {

    // MARK: - Feature Groups

    public var tabs: Tabs
    public var submissions: Submissions
    public var voting: Voting
    public var comments: Comments
    public var display: Display
    public var notifications: Notifications

    // MARK: - Init

    public init(
        tabs: Tabs = Tabs(),
        submissions: Submissions = Submissions(),
        voting: Voting = Voting(),
        comments: Comments = Comments(),
        display: Display = Display(),
        notifications: Notifications = Notifications()
    ) {
        self.tabs = tabs
        self.submissions = submissions
        self.voting = voting
        self.comments = comments
        self.display = display
        self.notifications = notifications
    }

    /// All features enabled (default fallback)
    public static var allEnabled: Features {
        Features()
    }

    // MARK: - Tab Features

    public struct Tabs: Decodable {
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

    public struct Submissions: Decodable {
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

    public struct Voting: Decodable {
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

    public struct Comments: Decodable {
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

    public struct Display: Decodable {
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

    public struct Notifications: Decodable {
        public var optInPrompt: Bool
        public var onStatusChange: Bool

        public init(optInPrompt: Bool = true, onStatusChange: Bool = true) {
            self.optInPrompt = optInPrompt
            self.onStatusChange = onStatusChange
        }
    }
}
