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

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Optional header label
            if let headerLabel = config.headerLabel {
                Text(headerLabel)
                    .font(.caption.bold())
                    .foregroundColor(theme.secondaryTextColor)
            }

            // Title row with icon, chevron, and dismiss button
            HStack(spacing: 10) {
                Image(systemName: "megaphone.fill")
                    .font(.body)
                    .foregroundColor(theme.accentColor)

                Text(announcement.title)
                    .font(config.titleFont ?? theme.titleFont)
                    .foregroundColor(config.titleColor ?? theme.primaryTextColor)
                    .lineLimit(1)

                Spacer()

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
        .background(config.backgroundColor ?? theme.accentColor.opacity(0.1))
        .cornerRadius(theme.cardStyle.cornerRadius)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}
