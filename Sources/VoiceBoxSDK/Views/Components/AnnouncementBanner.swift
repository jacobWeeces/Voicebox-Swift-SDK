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

            // Title row with dismiss button
            HStack {
                Text(announcement.title)
                    .font(config.titleFont ?? theme.titleFont)
                    .foregroundColor(config.titleColor ?? theme.primaryTextColor)
                    .lineLimit(1)

                Spacer()

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
        .background(config.backgroundColor)
        .cornerRadius(theme.cardStyle.cornerRadius)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}
