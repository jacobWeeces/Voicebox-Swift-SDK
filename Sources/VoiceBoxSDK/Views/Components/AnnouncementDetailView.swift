// Sources/VoiceBoxSDK/Views/Components/AnnouncementDetailView.swift
import SwiftUI

/// Full-screen detail view for an announcement, presented as a modal.
/// Parses the body as JSON sections and renders them in Apple-style grouped cards.
struct AnnouncementDetailView: View {
    let announcement: Announcement
    let onClose: () -> Void

    @Environment(\.voiceBoxTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme

    private var sections: [AnnouncementSection] {
        guard let data = announcement.body.data(using: .utf8),
              let parsed = try? JSONDecoder().decode([AnnouncementSection].self, from: data) else {
            return []
        }
        return parsed
    }

    private var headerBackground: Color {
        colorScheme == .dark
            ? Color(white: 0.11)
            : Color(white: 0.95)
    }

    private var cardBackground: Color {
        colorScheme == .dark
            ? Color(white: 0.17)
            : Color.white
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header area with close button + title
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Button(action: onClose) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()
                }

                Text(announcement.title)
                    .font(.title.bold())
                    .foregroundColor(theme.primaryTextColor)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(headerBackground)

            Divider()

            // Scrollable sections
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(Array(sections.enumerated()), id: \.offset) { _, section in
                        VStack(alignment: .leading, spacing: 12) {
                            Text(section.title)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.secondary)
                                .textCase(.uppercase)
                                .tracking(0.5)

                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(Array(section.items.enumerated()), id: \.offset) { idx, item in
                                    HStack(alignment: .top, spacing: 12) {
                                        Text("\u{2022}")
                                            .font(.body)
                                            .foregroundColor(theme.accentColor)

                                        Text(item)
                                            .font(.body)
                                            .foregroundColor(theme.primaryTextColor)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 16)

                                    if idx < section.items.count - 1 {
                                        Divider()
                                            .padding(.leading, 40)
                                    }
                                }
                            }
                            .background(cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: .black.opacity(colorScheme == .dark ? 0 : 0.04), radius: 2, y: 1)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 32)
            }
            .background(headerBackground)
        }
    }
}
