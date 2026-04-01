// Sources/VoiceBoxSDK/Views/Modifiers/AnnouncementBannerModifier.swift
import SwiftUI

/// View modifier that adds an inline announcement banner and full-screen detail modal.
struct AnnouncementBannerModifier: ViewModifier {
    let config: AnnouncementBannerConfiguration

    @ObservedObject private var manager = VoiceBox.announcement
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.voiceBoxTheme) private var theme
    @Environment(\.voiceBoxLocalization) private var l10n

    @State private var isModalPresented = false

    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            if config.position == .top {
                bannerView
            }

            content

            if config.position == .bottom {
                bannerView
            }
        }
        #if os(iOS)
        .fullScreenCover(isPresented: $isModalPresented) {
            if let announcement = manager.currentAnnouncement {
                AnnouncementDetailView(
                    announcement: announcement,
                    onClose: { isModalPresented = false }
                )
                .voiceBoxTheme(theme)
                .environment(\.voiceBoxLocalization, l10n)
            }
        }
        #else
        .sheet(isPresented: $isModalPresented) {
            if let announcement = manager.currentAnnouncement {
                AnnouncementDetailView(
                    announcement: announcement,
                    onClose: { isModalPresented = false }
                )
                .voiceBoxTheme(theme)
                .environment(\.voiceBoxLocalization, l10n)
            }
        }
        #endif
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

    @ViewBuilder
    private var bannerView: some View {
        if let announcement = manager.currentAnnouncement,
           manager.shouldShow(config: config),
           !manager.isDismissed {
            AnnouncementBanner(
                announcement: announcement,
                config: config,
                onTap: { isModalPresented = true },
                onDismiss: {
                    withAnimation(.easeOut(duration: 0.25)) {
                        manager.dismiss(config: config)
                    }
                }
            )
            .padding()
            .transition(.move(edge: config.position == .top ? .top : .bottom).combined(with: .opacity))
            .voiceBoxTheme(theme)
            .environment(\.voiceBoxLocalization, l10n)
        }
    }
}

// MARK: - View Extension

public extension View {
    /// Adds an inline announcement banner to this view.
    /// Tapping the banner opens a full-screen detail modal.
    /// - Parameter configure: Closure to customize banner configuration
    /// - Returns: View with inline announcement banner
    func voiceBoxAnnouncement(
        configure: ((inout AnnouncementBannerConfiguration) -> Void)? = nil
    ) -> some View {
        var config = AnnouncementBannerConfiguration()
        configure?(&config)
        return self.modifier(AnnouncementBannerModifier(config: config))
    }
}
