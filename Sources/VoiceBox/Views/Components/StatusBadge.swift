// packages/voicebox-swift/Sources/VoiceBox/Views/Components/StatusBadge.swift
import SwiftUI

struct StatusBadge: View {
    let status: FeedbackStatus

    @Environment(\.voiceBoxTheme) private var theme
    @Environment(\.voiceBoxLocalization) private var l10n

    var body: some View {
        Text(l10n.status(status))
            .font(.caption2.bold())
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(theme.statusColors.color(for: status))
            .clipShape(Capsule())
    }
}
