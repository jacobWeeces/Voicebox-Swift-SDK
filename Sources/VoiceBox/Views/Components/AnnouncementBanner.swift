// packages/voicebox-swift/Sources/VoiceBox/Views/Components/AnnouncementBanner.swift
import SwiftUI

struct AnnouncementBanner: View {
    let announcement: Announcement

    @Environment(\.voiceBoxTheme) private var theme
    @Environment(\.voiceBoxLocalization) private var l10n

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "megaphone.fill")
                    .foregroundColor(theme.accentColor)

                Text(l10n.announcementLabel)
                    .font(.caption.bold())
                    .foregroundColor(theme.accentColor)

                Spacer()
            }

            Text(announcement.title)
                .font(theme.titleFont)
                .foregroundColor(theme.primaryTextColor)

            Text(announcement.body)
                .font(theme.bodyFont)
                .foregroundColor(theme.secondaryTextColor)
        }
        .padding(theme.padding)
        .background(theme.accentColor.opacity(0.1))
        .cornerRadius(theme.cardStyle.cornerRadius)
    }
}
