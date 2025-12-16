// packages/voicebox-swift/Sources/VoiceBox/Views/Components/CommentRow.swift
import SwiftUI

struct CommentRow: View {
    let comment: Comment

    @Environment(\.voiceBoxTheme) private var theme
    @Environment(\.voiceBoxLocalization) private var l10n

    private var config: Configuration? {
        VoiceBox.shared.configuration
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack {
                if comment.isDeveloper {
                    if config?.features.comments.developerBadge == true {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.seal.fill")
                            Text(comment.developerName ?? l10n.developerBadge)
                        }
                        .font(.caption.bold())
                        .foregroundColor(theme.accentColor)
                    } else {
                        Text(comment.developerName ?? l10n.developerBadge)
                            .font(.caption.bold())
                    }
                } else {
                    Text("User")
                        .font(.caption)
                        .foregroundColor(theme.secondaryTextColor)
                }

                Spacer()

                if config?.features.display.timestamps == true {
                    Text(l10n.timeAgo(comment.createdAt))
                        .font(.caption)
                        .foregroundColor(theme.tertiaryTextColor)
                }
            }

            // Body
            Text(comment.body)
                .font(theme.bodyFont)
                .foregroundColor(theme.primaryTextColor)

            // Images
            if !comment.images.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(comment.images, id: \.self) { url in
                            AsyncImage(url: URL(string: url)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Rectangle()
                                    .fill(theme.tertiaryTextColor.opacity(0.3))
                            }
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
            }
        }
        .padding(theme.padding)
        .background(
            comment.isDeveloper ? theme.accentColor.opacity(0.05) : theme.secondaryBackgroundColor
        )
        .cornerRadius(theme.cardStyle.cornerRadius)
    }
}
