import Foundation

/// Configuration options for the announcement banner component.
///
/// Use this to customize the behavior, appearance, and interaction patterns
/// of announcement banners in your app.
///
/// Example:
/// ```swift
/// ContentView()
///     .voiceBoxAnnouncement { config in
///         config.dismissBehavior = .untilNewAnnouncement
///         config.isTappable = true
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

    /// Whether tapping the banner expands it to show the full body. Default is `true`.
    public var isTappable: Bool

    /// Where the banner appears on screen. Default is `.top`.
    public var position: Position

    /// Duration of expand/collapse animations in seconds. Default is `0.3`.
    public var animationDuration: Double

    /// Number of lines to show in collapsed state. `nil` shows full body. Default is `2`.
    public var collapsedBodyLines: Int?

    /// Custom label for the banner header. `nil` uses global localization. Default is `nil`.
    public var headerLabel: String?

    /// Creates a new announcement banner configuration with default values.
    ///
    /// - Parameters:
    ///   - dismissBehavior: How the banner handles dismissal. Default is `.untilNewAnnouncement`.
    ///   - isDismissible: Whether the user can dismiss the banner. Default is `true`.
    ///   - isTappable: Whether tapping expands the banner. Default is `true`.
    ///   - position: Where the banner appears. Default is `.top`.
    ///   - animationDuration: Animation duration in seconds. Default is `0.3`.
    ///   - collapsedBodyLines: Lines shown when collapsed. Default is `2`.
    ///   - headerLabel: Custom header label. Default is `nil` (uses global localization).
    public init(
        dismissBehavior: DismissBehavior = .untilNewAnnouncement,
        isDismissible: Bool = true,
        isTappable: Bool = true,
        position: Position = .top,
        animationDuration: Double = 0.3,
        collapsedBodyLines: Int? = 2,
        headerLabel: String? = nil
    ) {
        self.dismissBehavior = dismissBehavior
        self.isDismissible = isDismissible
        self.isTappable = isTappable
        self.position = position
        self.animationDuration = animationDuration
        self.collapsedBodyLines = collapsedBodyLines
        self.headerLabel = headerLabel
    }
}
