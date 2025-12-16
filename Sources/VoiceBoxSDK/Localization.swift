import Foundation
import SwiftUI

/// Localization strings for VoiceBox SDK
public struct Localization {

    // MARK: - Navigation

    public var requestsTab: String = "Requests"
    public var roadmapTab: String = "Roadmap"
    public var changelogTab: String = "Changelog"

    // MARK: - Buttons

    public var submitButton: String = "Submit"
    public var cancelButton: String = "Cancel"
    public var voteButton: String = "Vote"
    public var votedButton: String = "Voted"
    public var commentButton: String = "Comment"
    public var sendButton: String = "Send"

    // MARK: - Placeholders

    public var titlePlaceholder: String = "Feature title"
    public var descriptionPlaceholder: String = "Describe your idea..."
    public var commentPlaceholder: String = "Add a comment..."
    public var searchPlaceholder: String = "Search requests..."
    public var emailPlaceholder: String = "Email (for updates)"

    // MARK: - Labels

    public var votesLabel: String = "votes"
    public var voteLabel: String = "vote"
    public var commentsLabel: String = "comments"
    public var commentLabel: String = "comment"
    public var newRequestLabel: String = "New Request"
    public var announcementLabel: String = "From the Developer"

    // MARK: - Status Labels

    public var statusOpen: String = "Open"
    public var statusUnderReview: String = "Under Review"
    public var statusPlanned: String = "Planned"
    public var statusInProgress: String = "In Progress"
    public var statusCompleted: String = "Completed"
    public var statusDeclined: String = "Declined"

    // MARK: - Roadmap Columns

    public var roadmapPlanned: String = "Planned"
    public var roadmapInProgress: String = "In Progress"
    public var roadmapCompleted: String = "Completed"

    // MARK: - Empty States

    public var noRequestsTitle: String = "No requests yet"
    public var noRequestsMessage: String = "Be the first to suggest a feature!"
    public var noRoadmapTitle: String = "Roadmap coming soon"
    public var noRoadmapMessage: String = "Check back later for updates."
    public var noChangelogTitle: String = "No updates yet"
    public var noChangelogMessage: String = "We'll post updates here."

    // MARK: - Errors

    public var errorTitle: String = "Something went wrong"
    public var errorRetry: String = "Try Again"
    public var errorTitleRequired: String = "Please enter a title"
    public var errorDescriptionRequired: String = "Please enter a description"

    // MARK: - Success Messages

    public var requestSubmitted: String = "Thanks for your feedback!"
    public var commentAdded: String = "Comment added"

    // MARK: - Time

    public var justNow: String = "Just now"
    public var minutesAgo: String = "%d minutes ago"
    public var hoursAgo: String = "%d hours ago"
    public var daysAgo: String = "%d days ago"
    public var weeksAgo: String = "%d weeks ago"
    public var monthsAgo: String = "%d months ago"

    // MARK: - Developer Badge

    public var developerBadge: String = "Developer"

    // MARK: - Init

    public init() {}

    // MARK: - Helpers

    public func votes(count: Int) -> String {
        count == 1 ? "\(count) \(voteLabel)" : "\(count) \(votesLabel)"
    }

    public func comments(count: Int) -> String {
        count == 1 ? "\(count) \(commentLabel)" : "\(count) \(commentsLabel)"
    }

    public func status(_ status: FeedbackStatus) -> String {
        switch status {
        case .open: return statusOpen
        case .underReview: return statusUnderReview
        case .planned: return statusPlanned
        case .inProgress: return statusInProgress
        case .completed: return statusCompleted
        case .declined: return statusDeclined
        }
    }

    public func timeAgo(_ date: Date) -> String {
        let seconds = Int(-date.timeIntervalSinceNow)

        if seconds < 60 {
            return justNow
        } else if seconds < 3600 {
            let minutes = seconds / 60
            return String(format: minutesAgo, minutes)
        } else if seconds < 86400 {
            let hours = seconds / 3600
            return String(format: hoursAgo, hours)
        } else if seconds < 604800 {
            let days = seconds / 86400
            return String(format: daysAgo, days)
        } else if seconds < 2592000 {
            let weeks = seconds / 604800
            return String(format: weeksAgo, weeks)
        } else {
            let months = seconds / 2592000
            return String(format: monthsAgo, months)
        }
    }
}

// MARK: - Environment Key

private struct LocalizationKey: EnvironmentKey {
    static let defaultValue = Localization()
}

extension EnvironmentValues {
    var voiceBoxLocalization: Localization {
        get { self[LocalizationKey.self] }
        set { self[LocalizationKey.self] = newValue }
    }
}
