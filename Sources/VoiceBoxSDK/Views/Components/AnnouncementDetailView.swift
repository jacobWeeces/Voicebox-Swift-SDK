// Sources/VoiceBoxSDK/Views/Components/AnnouncementDetailView.swift
import SwiftUI

/// Full-screen detail view for an announcement, presented as a modal.
/// Parses the body as JSON sections and renders title + bullet items.
struct AnnouncementDetailView: View {
    let announcement: Announcement
    let onClose: () -> Void

    @Environment(\.voiceBoxTheme) private var theme

    private var sections: [AnnouncementSection] {
        guard let data = announcement.body.data(using: .utf8),
              let parsed = try? JSONDecoder().decode([AnnouncementSection].self, from: data) else {
            return []
        }
        return parsed
    }

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
                VStack(alignment: .leading, spacing: 24) {
                    // Top-level announcement title
                    Text(announcement.title)
                        .font(.title.bold())
                        .foregroundColor(theme.primaryTextColor)

                    // JSON sections
                    ForEach(Array(sections.enumerated()), id: \.offset) { _, section in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(section.title)
                                .font(.headline)
                                .foregroundColor(theme.primaryTextColor)

                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(Array(section.items.enumerated()), id: \.offset) { _, item in
                                    HStack(alignment: .top, spacing: 8) {
                                        Text("\u{2022}")
                                            .font(theme.bodyFont)
                                            .foregroundColor(theme.secondaryTextColor)

                                        Text(item)
                                            .font(theme.bodyFont)
                                            .foregroundColor(theme.secondaryTextColor)
                                    }
                                    .padding(.leading, 8)
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .background(theme.backgroundColor)
    }
}
