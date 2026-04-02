// Sources/VoiceBoxSDK/Views/Components/AnnouncementBanner.swift
import SwiftUI

/// A slim inline banner displaying an announcement title with dismiss and tap-to-open capabilities.
public struct AnnouncementBanner: View {
    let announcement: Announcement
    let config: AnnouncementBannerConfiguration
    let onTap: () -> Void
    let onDismiss: (() -> Void)?

    @Environment(\.voiceBoxTheme) private var theme

    public init(
        announcement: Announcement,
        config: AnnouncementBannerConfiguration = AnnouncementBannerConfiguration(),
        onTap: @escaping () -> Void,
        onDismiss: (() -> Void)? = nil
    ) {
        self.announcement = announcement
        self.config = config
        self.onTap = onTap
        self.onDismiss = onDismiss
    }

    @Environment(\.colorScheme) private var colorScheme

    public var body: some View {
        HStack(spacing: 0) {
            // Accent left edge
            RoundedRectangle(cornerRadius: 2)
                .fill(theme.accentColor)
                .frame(width: 3)

            VStack(alignment: .leading, spacing: 4) {
                // Optional header label
                if let headerLabel = config.headerLabel {
                    Text(headerLabel)
                        .font(.caption.bold())
                        .foregroundColor(theme.secondaryTextColor)
                }

                // Title row with chevron and dismiss button
                HStack(spacing: 12) {
                    Text(announcement.title)
                        .font(config.titleFont ?? theme.titleFont)
                        .foregroundColor(config.titleColor ?? theme.primaryTextColor)
                        .lineLimit(1)

                    Spacer()

                    // Tap indicator
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(theme.accentColor)

                    if config.isDismissible {
                        Button {
                            onDismiss?()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.caption.bold())
                                .foregroundColor(theme.secondaryTextColor)
                        }
                    }
                }
            }
            .padding(theme.padding)
        }
        .background(config.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: theme.cardStyle.cornerRadius))
        .shadow(
            color: .black.opacity(colorScheme == .dark ? 0.3 : 0.08),
            radius: 6,
            y: 3
        )
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}
