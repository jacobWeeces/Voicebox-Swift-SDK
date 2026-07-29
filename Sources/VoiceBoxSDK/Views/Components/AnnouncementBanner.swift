// Sources/VoiceBoxSDK/Views/Components/AnnouncementBanner.swift
import SwiftUI

/// A slim inline banner displaying an announcement title with dismiss and tap-to-open capabilities.
public struct AnnouncementBanner: View {
    let announcement: Announcement
    let config: AnnouncementBannerConfiguration
    let onTap: () -> Void
    let onDismiss: (() -> Void)?

    @Environment(\.voiceBoxTheme) private var theme
    @Environment(\.voiceBoxLocalization) private var l10n

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
        // Two sibling controls, not one tappable card with a glyph on top of it:
        // the open region and the dismiss button own separate, non-overlapping hit areas.
        HStack(spacing: 0) {
            openButton

            if config.isDismissible {
                dismissButton
            }
        }
        .background(config.backgroundColor ?? theme.accentColor.opacity(0.1))
        .cornerRadius(theme.cardStyle.cornerRadius)
    }

    private var openButton: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 4) {
                // Optional header label
                if let headerLabel = config.headerLabel {
                    Text(headerLabel)
                        .font(theme.captionBoldFont)
                        .foregroundColor(theme.secondaryTextColor)
                }

                // Title row with icon and chevron
                HStack(spacing: 10) {
                    Image(systemName: "megaphone.fill")
                        .font(theme.bodyFont)
                        .foregroundColor(theme.accentColor)

                    Text(announcement.title)
                        .font(config.titleFont ?? theme.titleFont)
                        .foregroundColor(config.titleColor ?? theme.primaryTextColor)
                        .lineLimit(1)

                    Spacer(minLength: 8)

                    Image(systemName: "chevron.right")
                        .font(theme.captionBoldFont)
                        .foregroundColor(theme.accentColor)
                }
            }
            .padding(theme.padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityHint(l10n.announcementOpenHint)
    }

    private var dismissButton: some View {
        Button {
            onDismiss?()
        } label: {
            Image(systemName: "xmark")
                .font(theme.captionBoldFont)
                .foregroundColor(theme.secondaryTextColor)
                // Visible chip so it reads as its own control, sitting in a
                // 44pt hit target per Apple's minimum touch size.
                .frame(width: 28, height: 28)
                .background(Circle().fill(theme.secondaryTextColor.opacity(0.15)))
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        // The 44pt frame already contributes 8pt around the 28pt chip; top up
        // the rest so the chip insets from the card edge like the title does.
        .padding(.trailing, max(0, theme.padding - 8))
        .accessibilityLabel(l10n.dismissButton)
    }
}
