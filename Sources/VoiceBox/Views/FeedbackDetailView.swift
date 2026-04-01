// packages/voicebox-swift/Sources/VoiceBox/Views/FeedbackDetailView.swift
import SwiftUI

struct FeedbackDetailView: View {
    let feedback: Feedback
    @ObservedObject var viewModel: FeedbackViewModel

    @State private var commentText = ""
    @State private var isSubmittingComment = false

    @Environment(\.dismiss) private var dismiss
    @Environment(\.voiceBoxTheme) private var theme
    @Environment(\.voiceBoxLocalization) private var l10n

    private var config: Configuration? {
        VoiceBox.shared.configuration
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: theme.spacing) {
                    // Header with vote button
                    headerSection

                    Divider()

                    // Description
                    descriptionSection

                    // Images
                    if !feedback.images.isEmpty {
                        imagesSection
                    }

                    Divider()

                    // Comments section
                    if config?.features.comments.enabled == true {
                        commentsSection
                    }
                }
                .padding()
            }
            .background(theme.backgroundColor)
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(theme.secondaryTextColor)
                    }
                }
            }
            .task {
                await viewModel.loadComments(for: feedback)
            }
        }
    }

    private var headerSection: some View {
        HStack(alignment: .top, spacing: 16) {
            // Vote button
            if config?.features.voting.enabled == true {
                VoteButton(
                    count: feedback.voteCount,
                    isVoted: feedback.userVoted ?? false,
                    showCount: config?.features.voting.showCounts ?? true,
                    action: {
                        Task {
                            await viewModel.toggleVote(for: feedback)
                        }
                    }
                )
            }

            VStack(alignment: .leading, spacing: 8) {
                // Title
                Text(feedback.title)
                    .font(.title2.bold())
                    .foregroundColor(theme.primaryTextColor)

                // Status badge
                if config?.features.display.statusBadges == true {
                    StatusBadge(status: feedback.status)
                }

                // Metadata
                if config?.features.display.timestamps == true {
                    Text(l10n.timeAgo(feedback.createdAt))
                        .font(theme.captionFont)
                        .foregroundColor(theme.tertiaryTextColor)
                }
            }
        }
    }

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description")
                .font(theme.titleFont)
                .foregroundColor(theme.primaryTextColor)

            Text(feedback.description)
                .font(theme.bodyFont)
                .foregroundColor(theme.secondaryTextColor)
        }
    }

    private var imagesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Images")
                .font(theme.titleFont)
                .foregroundColor(theme.primaryTextColor)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(feedback.images, id: \.self) { imageUrl in
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(theme.tertiaryTextColor.opacity(0.3))
                        }
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
        }
    }

    private var commentsSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing) {
            Text("\(l10n.commentsLabel.capitalized) (\(viewModel.comments.count))")
                .font(theme.titleFont)
                .foregroundColor(theme.primaryTextColor)

            // Comments list
            if viewModel.isLoadingComments {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else if viewModel.comments.isEmpty {
                Text("No comments yet")
                    .font(theme.bodyFont)
                    .foregroundColor(theme.secondaryTextColor)
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                ForEach(viewModel.comments) { comment in
                    CommentRow(comment: comment)
                }
            }

            // Comment input
            if config?.features.comments.enabled == true {
                commentInputSection
            }
        }
    }

    private var commentInputSection: some View {
        VStack(spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                TextField(l10n.commentPlaceholder, text: $commentText, axis: .vertical)
                    .textFieldStyle(.plain)
                    .padding(12)
                    .background(theme.secondaryBackgroundColor)
                    .cornerRadius(10)
                    .lineLimit(1...5)

                Button(action: submitComment) {
                    if isSubmittingComment {
                        ProgressView()
                            .frame(width: 44, height: 44)
                    } else {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(commentText.isEmpty ? theme.tertiaryTextColor : theme.accentColor)
                            .clipShape(Circle())
                    }
                }
                .disabled(commentText.isEmpty || isSubmittingComment)
            }
        }
    }

    private func submitComment() {
        guard !commentText.isEmpty else { return }

        let text = commentText
        commentText = ""
        isSubmittingComment = true

        Task {
            let success = await viewModel.addComment(to: feedback, body: text)
            isSubmittingComment = false

            if !success {
                commentText = text
            }
        }
    }
}
