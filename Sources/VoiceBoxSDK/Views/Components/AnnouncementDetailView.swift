// Sources/VoiceBoxSDK/Views/Components/AnnouncementDetailView.swift
import SwiftUI

/// Full-screen detail view for an announcement, presented as a modal.
/// Parses the body as JSON sections and renders them in premium Apple-style grouped cards.
struct AnnouncementDetailView: View {
    let announcement: Announcement
    let onClose: () -> Void

    @Environment(\.voiceBoxTheme) private var theme
    @Environment(\.voiceBoxLocalization) private var l10n
    @Environment(\.colorScheme) private var colorScheme

    private var sections: [AnnouncementSection] {
        guard let data = announcement.body.data(using: .utf8),
              let parsed = try? JSONDecoder().decode([AnnouncementSection].self, from: data) else {
            return []
        }
        return parsed
    }

    private var contentBackground: Color {
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
            // Header with accent gradient wash
            ZStack(alignment: .topLeading) {
                // Gradient background
                LinearGradient(
                    colors: [
                        theme.accentColor.opacity(colorScheme == .dark ? 0.15 : 0.08),
                        theme.accentColor.opacity(0.02),
                        contentBackground
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 200)

                VStack(alignment: .leading, spacing: 16) {
                    // Close button
                    HStack {
                        Button(action: onClose) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()
                    }

                    // Badge
                    Text(l10n.announcementLabel)
                        .font(.caption.weight(.semibold))
                        .foregroundColor(theme.accentColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(theme.accentColor.opacity(colorScheme == .dark ? 0.2 : 0.12))
                        )

                    // Title
                    Text(announcement.title)
                        .font(.largeTitle.bold())
                        .foregroundColor(theme.primaryTextColor)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
            }

            // Scrollable sections
            ScrollView {
                VStack(spacing: 24) {
                    ForEach(Array(sections.enumerated()), id: \.offset) { _, section in
                        VStack(alignment: .leading, spacing: 10) {
                            // Section header
                            Text(section.title)
                                .font(.title3.bold())
                                .foregroundColor(theme.primaryTextColor)
                                .padding(.leading, 4)

                            // Items card
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(Array(section.items.enumerated()), id: \.offset) { idx, item in
                                    HStack(alignment: .top, spacing: 14) {
                                        Circle()
                                            .fill(theme.accentColor)
                                            .frame(width: 6, height: 6)
                                            .padding(.top, 7)

                                        Text(item)
                                            .font(.body)
                                            .foregroundColor(theme.primaryTextColor)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 18)

                                    if idx < section.items.count - 1 {
                                        Divider()
                                            .padding(.leading, 38)
                                    }
                                }
                            }
                            .background(cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(color: .black.opacity(colorScheme == .dark ? 0 : 0.06), radius: 4, y: 2)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
            .background(contentBackground)
        }
    }
}
