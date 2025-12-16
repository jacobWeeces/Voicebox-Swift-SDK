// Sources/VoiceBox/Views/Modifiers/AnnouncementBannerModifier.swift
import SwiftUI

/// View modifier that adds an announcement banner overlay
struct AnnouncementBannerModifier: ViewModifier {
    let config: AnnouncementBannerConfiguration

    @ObservedObject private var manager = VoiceBox.announcement
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.voiceBoxTheme) private var theme
    @Environment(\.voiceBoxLocalization) private var l10n

    func body(content: Content) -> some View {
        content
            .overlay(alignment: config.position == .top ? .top : .bottom) {
                if let announcement = manager.currentAnnouncement,
                   manager.shouldShow(config: config),
                   !manager.isDismissed {
                    AnnouncementBanner(
                        announcement: announcement,
                        config: config
                    ) {
                        withAnimation(.easeOut(duration: 0.25)) {
                            manager.dismiss(config: config)
                        }
                    }
                    .padding()
                    .transition(.move(edge: config.position == .top ? .top : .bottom).combined(with: .opacity))
                    .voiceBoxTheme(theme)
                    .environment(\.voiceBoxLocalization, l10n)
                }
            }
            .task {
                await manager.refresh()
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    Task {
                        await manager.refresh()
                    }
                }
            }
    }
}

// MARK: - View Extension

public extension View {
    /// Adds an announcement banner to this view
    /// - Parameter configure: Closure to customize banner configuration
    /// - Returns: View with announcement banner overlay
    func voiceBoxAnnouncement(
        configure: ((inout AnnouncementBannerConfiguration) -> Void)? = nil
    ) -> some View {
        var config = AnnouncementBannerConfiguration()
        configure?(&config)
        return self.modifier(AnnouncementBannerModifier(config: config))
    }
}
