import SwiftUI

/// Visual theme for VoiceBox SDK
public struct Theme {

    // MARK: - Colors

    /// Primary accent color (defaults to app's AccentColor from Assets)
    public var accentColor: Color = .accentColor

    /// Background color
    #if canImport(UIKit)
    public var backgroundColor: Color = Color(uiColor: .systemBackground)
    #elseif canImport(AppKit)
    public var backgroundColor: Color = Color(nsColor: .windowBackgroundColor)
    #else
    public var backgroundColor: Color = Color.white
    #endif

    /// Secondary background color (for cards)
    #if canImport(UIKit)
    public var secondaryBackgroundColor: Color = Color(uiColor: .secondarySystemBackground)
    #elseif canImport(AppKit)
    public var secondaryBackgroundColor: Color = Color(nsColor: .controlBackgroundColor)
    #else
    public var secondaryBackgroundColor: Color = Color.gray.opacity(0.1)
    #endif

    /// Primary text color
    #if canImport(UIKit)
    public var primaryTextColor: Color = Color(uiColor: .label)
    #elseif canImport(AppKit)
    public var primaryTextColor: Color = Color(nsColor: .labelColor)
    #else
    public var primaryTextColor: Color = Color.black
    #endif

    /// Secondary text color
    #if canImport(UIKit)
    public var secondaryTextColor: Color = Color(uiColor: .secondaryLabel)
    #elseif canImport(AppKit)
    public var secondaryTextColor: Color = Color(nsColor: .secondaryLabelColor)
    #else
    public var secondaryTextColor: Color = Color.gray
    #endif

    /// Tertiary text color
    #if canImport(UIKit)
    public var tertiaryTextColor: Color = Color(uiColor: .tertiaryLabel)
    #elseif canImport(AppKit)
    public var tertiaryTextColor: Color = Color(nsColor: .tertiaryLabelColor)
    #else
    public var tertiaryTextColor: Color = Color.gray.opacity(0.6)
    #endif

    // MARK: - Card Style

    /// Card visual style
    public var cardStyle: CardStyle = .rounded

    public enum CardStyle {
        case rounded
        case flat
        case bordered

        var cornerRadius: CGFloat {
            switch self {
            case .rounded: return 12
            case .flat: return 0
            case .bordered: return 8
            }
        }

        var hasShadow: Bool {
            switch self {
            case .rounded: return true
            case .flat, .bordered: return false
            }
        }

        var hasBorder: Bool {
            switch self {
            case .bordered: return true
            case .rounded, .flat: return false
            }
        }
    }

    // MARK: - Status Colors

    /// Colors for feedback status badges
    public var statusColors: StatusColors = StatusColors()

    public struct StatusColors {
        public var open: Color = .gray
        public var underReview: Color = .orange
        public var planned: Color = .blue
        public var inProgress: Color = .purple
        public var completed: Color = .green
        public var declined: Color = .red

        public init() {}

        public func color(for status: FeedbackStatus) -> Color {
            switch status {
            case .open: return open
            case .underReview: return underReview
            case .planned: return planned
            case .inProgress: return inProgress
            case .completed: return completed
            case .declined: return declined
            }
        }
    }

    // MARK: - Typography

    /// Font for titles
    public var titleFont: Font = .headline

    /// Font for body text
    public var bodyFont: Font = .body

    /// Font for captions
    public var captionFont: Font = .caption

    // MARK: - Spacing

    /// Standard padding
    public var padding: CGFloat = 16

    /// Spacing between items
    public var spacing: CGFloat = 12

    // MARK: - Init

    public init() {}
}

// MARK: - Environment Key

private struct ThemeKey: EnvironmentKey {
    static let defaultValue = Theme()
}

extension EnvironmentValues {
    var voiceBoxTheme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

// MARK: - View Extension

extension View {
    func voiceBoxTheme(_ theme: Theme) -> some View {
        environment(\.voiceBoxTheme, theme)
    }
}
