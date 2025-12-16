// packages/voicebox-swift/Sources/VoiceBox/Views/Components/VoteButton.swift
import SwiftUI

struct VoteButton: View {
    let count: Int
    let isVoted: Bool
    let showCount: Bool
    let action: () -> Void

    @Environment(\.voiceBoxTheme) private var theme

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: isVoted ? "arrow.up.circle.fill" : "arrow.up.circle")
                    .font(.title2)
                    .foregroundColor(isVoted ? theme.accentColor : theme.secondaryTextColor)

                if showCount {
                    Text("\(count)")
                        .font(.caption.bold())
                        .foregroundColor(isVoted ? theme.accentColor : theme.secondaryTextColor)
                }
            }
            .frame(width: 44)
        }
        .buttonStyle(.plain)
    }
}
