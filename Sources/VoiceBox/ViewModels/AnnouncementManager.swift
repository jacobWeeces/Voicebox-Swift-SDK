import Foundation
import SwiftUI

/// Manages announcement state, fetching, and dismiss persistence.
///
/// This class handles the lifecycle of announcements, including:
/// - Fetching the current active announcement from the API
/// - Managing expand/collapse state
/// - Persisting dismiss state according to configuration
/// - Determining when announcements should be shown
@MainActor
public final class AnnouncementManager: ObservableObject {

    // MARK: - Published Properties

    /// The current active announcement from the server, if any.
    @Published public var currentAnnouncement: Announcement?

    /// Whether the announcement banner is currently expanded to show full body.
    @Published public var isExpanded: Bool = false

    /// Whether the user has dismissed the current announcement.
    @Published public var isDismissed: Bool = false

    /// Whether the manager is currently fetching data.
    @Published public var isLoading: Bool = false

    /// The last error that occurred during fetch operations.
    @Published public var error: Error?

    // MARK: - Private

    private let api = VoiceBox.shared.api
    private let defaults = UserDefaults.standard

    // UserDefaults keys
    private func dismissedKey(for announcementId: UUID) -> String {
        "voicebox.dismissed.\(announcementId.uuidString)"
    }

    private let sessionDismissedKey = "voicebox.dismissed.session"

    // MARK: - Init

    public init() {}

    // MARK: - Actions

    /// Fetches the current active announcement from the API.
    ///
    /// This method:
    /// - Sets `isLoading` to true during the fetch
    /// - Updates `currentAnnouncement` with the result
    /// - Resets `isDismissed` if a new announcement is detected
    /// - Sets `error` if the fetch fails
    public func refresh() async {
        isLoading = true
        error = nil

        do {
            let announcement = try await api.fetchAnnouncement()

            // If we got a new announcement different from the current one,
            // reset the dismissed state (user should see the new announcement)
            if let newAnnouncement = announcement,
               let current = currentAnnouncement,
               newAnnouncement.id != current.id {
                isDismissed = false
            }

            currentAnnouncement = announcement
        } catch {
            self.error = error
        }

        isLoading = false
    }

    /// Determines if the announcement should be shown based on configuration and dismiss state.
    ///
    /// - Parameter config: The banner configuration to check against
    /// - Returns: `true` if the announcement should be displayed, `false` otherwise
    ///
    /// This method checks:
    /// - Whether an announcement exists
    /// - Session-only dismiss state
    /// - Forever/timed dismiss state
    /// - Current `isDismissed` flag
    public func shouldShow(config: AnnouncementBannerConfiguration) -> Bool {
        guard let announcement = currentAnnouncement else {
            return false
        }

        // Check session-only dismissal
        if case .sessionOnly = config.dismissBehavior {
            if let sessionId = defaults.string(forKey: sessionDismissedKey),
               sessionId == announcement.id.uuidString {
                return false
            }
        }

        // Check forever/timed dismissal
        let key = dismissedKey(for: announcement.id)
        if let dismissedDate = defaults.object(forKey: key) as? Date {
            switch config.dismissBehavior {
            case .forever:
                return false
            case .timed(let hours):
                let hoursSinceDismiss = Date().timeIntervalSince(dismissedDate) / 3600
                if hoursSinceDismiss < Double(hours) {
                    return false
                }
            case .untilNewAnnouncement:
                // For untilNewAnnouncement, we hide if this specific announcement was dismissed
                return false
            case .sessionOnly:
                break // Already handled above
            }
        }

        return !isDismissed
    }

    /// Dismisses the current announcement and persists state according to configuration.
    ///
    /// - Parameter config: The banner configuration determining how dismissal is persisted
    ///
    /// Persistence behavior:
    /// - `.sessionOnly`: Stored in UserDefaults, cleared on app restart
    /// - `.untilNewAnnouncement`: Persisted until announcement ID changes
    /// - `.forever`: Persisted permanently for this announcement ID
    /// - `.timed(hours)`: Persisted with timestamp, re-shown after specified hours
    public func dismiss(config: AnnouncementBannerConfiguration) {
        guard let announcement = currentAnnouncement else {
            return
        }

        isDismissed = true

        switch config.dismissBehavior {
        case .sessionOnly:
            defaults.set(announcement.id.uuidString, forKey: sessionDismissedKey)

        case .untilNewAnnouncement, .forever:
            let key = dismissedKey(for: announcement.id)
            defaults.set(Date(), forKey: key)

        case .timed:
            let key = dismissedKey(for: announcement.id)
            defaults.set(Date(), forKey: key)
        }
    }

    /// Resets all dismiss state for the current announcement.
    ///
    /// This is useful for:
    /// - Testing/debugging
    /// - Providing a "show dismissed announcements" feature
    /// - Clearing state when logging out or switching accounts
    public func resetDismissState() {
        // Clear session dismissal
        defaults.removeObject(forKey: sessionDismissedKey)

        // Clear current announcement's specific dismissal
        if let announcement = currentAnnouncement {
            let key = dismissedKey(for: announcement.id)
            defaults.removeObject(forKey: key)
        }

        isDismissed = false
    }
}
