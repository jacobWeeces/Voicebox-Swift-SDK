import SwiftUI

/// Configuration options for the announcement banner component.
///
/// Example:
/// ```swift
/// ContentView()
///     .voiceBoxAnnouncement { config in
///         config.dismissBehavior = .untilNewAnnouncement
///         config.isDismissible = true
///         config.position = .top
///     }
/// ```
public struct AnnouncementBannerConfiguration {

    /// Controls how long a dismissed announcement stays hidden.
    public enum DismissBehavior {
        /// Banner reappears on app restart.
        case sessionOnly

        /// Banner stays hidden until a different announcement is active.
        case untilNewAnnouncement

        /// This specific announcement never shows again.
        case forever

        /// Banner reappears after the specified number of hours.
        case timed(hours: Int)
    }

    /// Controls where the banner appears on screen.
    public enum Position {
        /// Banner appears at the top of the screen.
        case top

        /// Banner appears at the bottom of the screen.
        case bottom
    }

    /// How the banner handles dismissal. Default is `.untilNewAnnouncement`.
    public var dismissBehavior: DismissBehavior

    /// Whether the user can dismiss the banner. Default is `true`.
    public var isDismissible: Bool

    /// Where the banner appears on screen. Default is `.top`.
    public var position: Position

    /// Custom label for the banner header. `nil` hides the header. Default is `nil`.
    public var headerLabel: String?

    /// Background color of the banner card. `nil` uses a subtle accent tint. Default is `nil`.
    public var backgroundColor: Color?

    /// Override font for the banner title. `nil` uses theme default. Default is `nil`.
    public var titleFont: Font?

    /// Override color for the banner title. `nil` uses theme default. Default is `nil`.
    public var titleColor: Color?

    public init(
        dismissBehavior: DismissBehavior = .untilNewAnnouncement,
        isDismissible: Bool = true,
        position: Position = .top,
        headerLabel: String? = nil,
        backgroundColor: Color? = nil,
        titleFont: Font? = nil,
        titleColor: Color? = nil
    ) {
        self.dismissBehavior = dismissBehavior
        self.isDismissible = isDismissible
        self.position = position
        self.headerLabel = headerLabel
        self.backgroundColor = backgroundColor
        self.titleFont = titleFont
        self.titleColor = titleColor
    }
}
