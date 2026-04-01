// packages/voicebox-swift/Sources/VoiceBox/Views/Components/FeedbackCard.swift
import SwiftUI

struct FeedbackCard: View {
    let feedback: Feedback
    let onVote: () -> Void

    @Environment(\.voiceBoxTheme) private var theme
    @Environment(\.voiceBoxLocalization) private var l10n

    private var config: Configuration? {
        VoiceBox.shared.configuration
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Vote button
            if config?.features.voting.enabled == true {
                VoteButton(
                    count: feedback.voteCount,
                    isVoted: feedback.userVoted ?? false,
                    showCount: config?.features.voting.showCounts ?? true,
                    action: onVote
                )
            }

            // Content
            VStack(alignment: .leading, spacing: 8) {
                // Title and status
                HStack {
                    Text(feedback.title)
                        .font(theme.titleFont)
                        .foregroundColor(theme.primaryTextColor)
                        .lineLimit(2)

                    Spacer()

                    if config?.features.display.statusBadges == true {
                        StatusBadge(status: feedback.status)
                    }
                }

                // Description preview
                Text(feedback.description)
                    .font(theme.bodyFont)
                    .foregroundColor(theme.secondaryTextColor)
                    .lineLimit(2)

                // Meta info
                HStack(spacing: 12) {
                    if let commentCount = feedback.commentCount, commentCount > 0 {
                        Label(l10n.comments(count: Int(commentCount)), systemImage: "bubble.left")
                    }

                    if !feedback.images.isEmpty {
                        Label("\(feedback.images.count)", systemImage: "photo")
                    }

                    if config?.features.display.timestamps == true {
                        Text(l10n.timeAgo(feedback.createdAt))
                    }
                }
                .font(theme.captionFont)
                .foregroundColor(theme.tertiaryTextColor)
            }
        }
        .padding(theme.padding)
        .background(theme.secondaryBackgroundColor)
        .cornerRadius(theme.cardStyle.cornerRadius)
        .shadow(
            color: theme.cardStyle.hasShadow ? .black.opacity(0.1) : .clear,
            radius: 4, y: 2
        )
        .overlay(
            RoundedRectangle(cornerRadius: theme.cardStyle.cornerRadius)
                .stroke(theme.cardStyle.hasBorder ? theme.tertiaryTextColor.opacity(0.3) : .clear, lineWidth: 1)
        )
    }
}
