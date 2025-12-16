// Sources/VoiceBox/Views/Components/AnnouncementBanner.swift
import SwiftUI

/// A banner displaying an announcement with expand/collapse and dismiss capabilities
public struct AnnouncementBanner: View {
    let announcement: Announcement
    let config: AnnouncementBannerConfiguration
    let onDismiss: (() -> Void)?

    @State private var isExpanded: Bool = false
    @Environment(\.voiceBoxTheme) private var theme
    @Environment(\.voiceBoxLocalization) private var l10n

    public init(
        announcement: Announcement,
        config: AnnouncementBannerConfiguration = AnnouncementBannerConfiguration(),
        onDismiss: (() -> Void)? = nil
    ) {
        self.announcement = announcement
        self.config = config
        self.onDismiss = onDismiss
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header row
            HStack {
                Image(systemName: "megaphone.fill")
                    .foregroundColor(theme.accentColor)

                Text(config.headerLabel ?? l10n.announcementLabel)
                    .font(.caption.bold())
                    .foregroundColor(theme.accentColor)

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

            // Title
            Text(announcement.title)
                .font(theme.titleFont)
                .foregroundColor(theme.primaryTextColor)

            // Body
            if isExpanded {
                Text(announcement.body)
                    .font(theme.bodyFont)
                    .foregroundColor(theme.secondaryTextColor)

                if config.isTappable {
                    HStack {
                        Spacer()
                        Text("Tap to collapse")
                            .font(.caption)
                            .foregroundColor(theme.secondaryTextColor.opacity(0.7))
                    }
                }
            } else {
                Text(announcement.body)
                    .font(theme.bodyFont)
                    .foregroundColor(theme.secondaryTextColor)
                    .lineLimit(config.collapsedBodyLines)
            }
        }
        .padding(theme.padding)
        .background(theme.accentColor.opacity(0.1))
        .cornerRadius(theme.cardStyle.cornerRadius)
        .contentShape(Rectangle())
        .onTapGesture {
            if config.isTappable {
                withAnimation(.spring(duration: config.animationDuration)) {
                    isExpanded.toggle()
                }
            }
        }
    }
}
