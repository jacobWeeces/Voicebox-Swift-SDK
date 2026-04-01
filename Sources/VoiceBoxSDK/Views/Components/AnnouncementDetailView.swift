// Sources/VoiceBoxSDK/Views/Components/AnnouncementDetailView.swift
import SwiftUI

/// Full-screen detail view for an announcement, presented as a modal.
/// Renders the body text with basic markdown support (bold, italic, links, strikethrough).
struct AnnouncementDetailView: View {
    let announcement: Announcement
    let onClose: () -> Void

    @Environment(\.voiceBoxTheme) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Close button
            HStack {
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.body.bold())
                        .foregroundColor(theme.secondaryTextColor)
                        .padding(8)
                }

                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)

            // Scrollable content
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(announcement.title)
                        .font(.title.bold())
                        .foregroundColor(theme.primaryTextColor)

                    Text(LocalizedStringKey(announcement.body))
                        .font(theme.bodyFont)
                        .foregroundColor(theme.secondaryTextColor)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .background(theme.backgroundColor)
    }
}
