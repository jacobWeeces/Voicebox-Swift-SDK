// packages/voicebox-swift/Sources/VoiceBox/Views/ChangelogView.swift
import SwiftUI

struct VoiceBoxChangelogView: View {
    @StateObject private var viewModel = ChangelogViewModel()

    @Environment(\.voiceBoxTheme) private var theme
    @Environment(\.voiceBoxLocalization) private var l10n

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.entries.isEmpty {
                    ProgressView()
                } else if viewModel.entries.isEmpty && !viewModel.isLoading {
                    emptyState
                } else {
                    contentView
                }
            }
            .navigationTitle(l10n.changelogTab)
            .task {
                await viewModel.loadChangelog()
            }
            .refreshable {
                await viewModel.loadChangelog()
            }
        }
    }

    private var contentView: some View {
        ScrollView {
            LazyVStack(spacing: theme.spacing) {
                ForEach(viewModel.entries) { entry in
                    changelogCard(entry: entry)
                }
            }
            .padding()
        }
        .background(theme.backgroundColor)
    }

    private func changelogCard(entry: ChangelogEntry) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with version and date
            HStack {
                if let version = entry.version {
                    Text(version)
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(theme.accentColor)
                        .clipShape(Capsule())
                }

                Spacer()

                if let publishedAt = entry.publishedAt {
                    Text(l10n.timeAgo(publishedAt))
                        .font(theme.captionFont)
                        .foregroundColor(theme.tertiaryTextColor)
                }
            }

            // Title
            Text(entry.title)
                .font(.title3.bold())
                .foregroundColor(theme.primaryTextColor)

            // Body
            Text(entry.body)
                .font(theme.bodyFont)
                .foregroundColor(theme.secondaryTextColor)

            Divider()
        }
        .padding(theme.padding)
        .background(theme.secondaryBackgroundColor)
        .cornerRadius(theme.cardStyle.cornerRadius)
        .shadow(
            color: theme.cardStyle.hasShadow ? .black.opacity(0.1) : .clear,
            radius: 4, y: 2
        )
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "newspaper")
                .font(.system(size: 60))
                .foregroundColor(theme.tertiaryTextColor)

            Text(l10n.noChangelogTitle)
                .font(theme.titleFont)
                .foregroundColor(theme.primaryTextColor)

            Text(l10n.noChangelogMessage)
                .font(theme.bodyFont)
                .foregroundColor(theme.secondaryTextColor)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
