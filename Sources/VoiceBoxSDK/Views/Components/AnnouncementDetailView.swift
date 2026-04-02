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

    @State private var appeared = false

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
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Title
                    Text(announcement.title)
                        .font(.largeTitle.bold())
                        .foregroundColor(theme.primaryTextColor)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                        .padding(.bottom, 20)

                    // Sections
                    VStack(spacing: 28) {
                        ForEach(Array(sections.enumerated()), id: \.offset) { sectionIndex, section in
                            VStack(alignment: .leading, spacing: 10) {
                                // Section header with accent underline
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(section.title)
                                        .font(.title3.bold())
                                        .foregroundColor(theme.primaryTextColor)
                                        .padding(.leading, 4)

                                    RoundedRectangle(cornerRadius: 1.5)
                                        .fill(theme.accentColor)
                                        .frame(width: 32, height: 3)
                                        .padding(.leading, 4)
                                }

                                // Items card with accent left border
                                HStack(spacing: 0) {
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(theme.accentColor)
                                        .frame(width: 3)

                                    VStack(alignment: .leading, spacing: 0) {
                                        ForEach(Array(section.items.enumerated()), id: \.offset) { idx, item in
                                            HStack(alignment: .top, spacing: 14) {
                                                Circle()
                                                    .fill(theme.accentColor)
                                                    .frame(width: 8, height: 8)
                                                    .padding(.top, 7)

                                                Text(item)
                                                    .font(.body.weight(.medium))
                                                    .foregroundColor(theme.primaryTextColor)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                            }
                                            .padding(.vertical, 16)
                                            .padding(.horizontal, 18)

                                            if idx < section.items.count - 1 {
                                                Divider()
                                                    .padding(.leading, 40)
                                            }
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                .background(cardBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .shadow(
                                    color: .black.opacity(colorScheme == .dark ? 0.3 : 0.1),
                                    radius: 8,
                                    y: 4
                                )
                            }
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : 20)
                            .animation(
                                .spring(response: 0.5, dampingFraction: 0.8)
                                    .delay(Double(sectionIndex) * 0.1),
                                value: appeared
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
            .background(contentBackground)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: onClose) {
                        Image(systemName: "xmark.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.secondary)
                            .font(.title3)
                    }
                }
            }
        }
        .onAppear {
            appeared = true
        }
    }
}
