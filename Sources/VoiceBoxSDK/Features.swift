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

    // MARK: - Decodable with defaults for missing fields

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        tabs = try container.decodeIfPresent(Tabs.self, forKey: .tabs) ?? Tabs()
        submissions = try container.decodeIfPresent(Submissions.self, forKey: .submissions) ?? Submissions()
        voting = try container.decodeIfPresent(Voting.self, forKey: .voting) ?? Voting()
        comments = try container.decodeIfPresent(Comments.self, forKey: .comments) ?? Comments()
        display = try container.decodeIfPresent(Display.self, forKey: .display) ?? Display()
        notifications = try container.decodeIfPresent(Notifications.self, forKey: .notifications) ?? Notifications()
    }

    private enum CodingKeys: String, CodingKey {
        case tabs, submissions, voting, comments, display, notifications
    }

    // MARK: - Tab Features

    public struct Tabs: Decodable {
        public var requests: Bool
        public var changelog: Bool

        public init(requests: Bool = true, changelog: Bool = true) {
            self.requests = requests
            self.changelog = changelog
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            requests = try container.decodeIfPresent(Bool.self, forKey: .requests) ?? true
            changelog = try container.decodeIfPresent(Bool.self, forKey: .changelog) ?? true
        }

        private enum CodingKeys: String, CodingKey {
            case requests, changelog
        }
    }

    // MARK: - Submission Features

    public struct Submissions: Decodable {
        public var enabled: Bool
        public var images: Bool
        public var anonymous: Bool
        public var requireEmail: Bool
        public var requireApproval: Bool

        public init(enabled: Bool = true, images: Bool = true, anonymous: Bool = true, requireEmail: Bool = false, requireApproval: Bool = false) {
            self.enabled = enabled
            self.images = images
            self.anonymous = anonymous
            self.requireEmail = requireEmail
            self.requireApproval = requireApproval
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            enabled = try container.decodeIfPresent(Bool.self, forKey: .enabled) ?? true
            images = try container.decodeIfPresent(Bool.self, forKey: .images) ?? true
            anonymous = try container.decodeIfPresent(Bool.self, forKey: .anonymous) ?? true
            requireEmail = try container.decodeIfPresent(Bool.self, forKey: .requireEmail) ?? false
            requireApproval = try container.decodeIfPresent(Bool.self, forKey: .requireApproval) ?? false
        }

        private enum CodingKeys: String, CodingKey {
            case enabled, images, anonymous, requireEmail, requireApproval
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

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            enabled = try container.decodeIfPresent(Bool.self, forKey: .enabled) ?? true
            allowUnvote = try container.decodeIfPresent(Bool.self, forKey: .allowUnvote) ?? true
            showCounts = try container.decodeIfPresent(Bool.self, forKey: .showCounts) ?? true
        }

        private enum CodingKeys: String, CodingKey {
            case enabled, allowUnvote, showCounts
        }
    }

    // MARK: - Comment Features

    public struct Comments: Decodable {
        public var enabled: Bool
        public var images: Bool
        public var developerBadge: Bool
        public var allowUserComments: Bool
        public var requireApproval: Bool

        public init(enabled: Bool = true, images: Bool = true, developerBadge: Bool = true, allowUserComments: Bool = true, requireApproval: Bool = false) {
            self.enabled = enabled
            self.images = images
            self.developerBadge = developerBadge
            self.allowUserComments = allowUserComments
            self.requireApproval = requireApproval
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            enabled = try container.decodeIfPresent(Bool.self, forKey: .enabled) ?? true
            images = try container.decodeIfPresent(Bool.self, forKey: .images) ?? true
            developerBadge = try container.decodeIfPresent(Bool.self, forKey: .developerBadge) ?? true
            allowUserComments = try container.decodeIfPresent(Bool.self, forKey: .allowUserComments) ?? true
            requireApproval = try container.decodeIfPresent(Bool.self, forKey: .requireApproval) ?? false
        }

        private enum CodingKeys: String, CodingKey {
            case enabled, images, developerBadge, allowUserComments, requireApproval
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

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            statusBadges = try container.decodeIfPresent(Bool.self, forKey: .statusBadges) ?? true
            userAvatars = try container.decodeIfPresent(Bool.self, forKey: .userAvatars) ?? true
            announcement = try container.decodeIfPresent(Bool.self, forKey: .announcement) ?? true
            searchBar = try container.decodeIfPresent(Bool.self, forKey: .searchBar) ?? true
            timestamps = try container.decodeIfPresent(Bool.self, forKey: .timestamps) ?? true
        }

        private enum CodingKeys: String, CodingKey {
            case statusBadges, userAvatars, announcement, searchBar, timestamps
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

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            optInPrompt = try container.decodeIfPresent(Bool.self, forKey: .optInPrompt) ?? true
            onStatusChange = try container.decodeIfPresent(Bool.self, forKey: .onStatusChange) ?? true
        }

        private enum CodingKeys: String, CodingKey {
            case optInPrompt, onStatusChange
        }
    }
}
