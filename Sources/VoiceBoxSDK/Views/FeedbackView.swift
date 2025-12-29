// packages/voicebox-swift/Sources/VoiceBox/Views/FeedbackView.swift
import SwiftUI

public struct VoiceBoxFeedbackView: View {
    @Environment(\.voiceBoxTheme) private var theme
    @Environment(\.voiceBoxLocalization) private var l10n

    private var config: Configuration? {
        VoiceBox.shared.configuration
    }

    public init() {}

    public var body: some View {
        TabView {
            // Requests tab
            if config?.features.tabs.requests == true {
                FeedbackListView()
                    .tabItem {
                        Label(l10n.requestsTab, systemImage: "lightbulb")
                    }
            }

            // Changelog tab
            if config?.features.tabs.changelog == true {
                VoiceBoxChangelogView()
                    .tabItem {
                        Label(l10n.changelogTab, systemImage: "newspaper")
                    }
            }
        }
        .accentColor(theme.accentColor)
    }
}
