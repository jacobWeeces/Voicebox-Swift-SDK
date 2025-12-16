import SwiftUI

// MARK: - Public View Accessors

extension VoiceBox {

    /// Full tabbed feedback view with requests, roadmap, and changelog
    public static func FeedbackView() -> some View {
        VoiceBoxFeedbackView()
            .voiceBoxTheme(shared.configuration?.theme ?? Theme())
            .environment(\.voiceBoxLocalization, shared.configuration?.localization ?? Localization())
    }

    /// Just the requests list view
    public static func RequestsView() -> some View {
        FeedbackListView()
            .voiceBoxTheme(shared.configuration?.theme ?? Theme())
            .environment(\.voiceBoxLocalization, shared.configuration?.localization ?? Localization())
    }

    /// Just the roadmap view
    public static func RoadmapView() -> some View {
        VoiceBoxRoadmapView()
            .voiceBoxTheme(shared.configuration?.theme ?? Theme())
            .environment(\.voiceBoxLocalization, shared.configuration?.localization ?? Localization())
    }

    /// Just the changelog view
    public static func ChangelogView() -> some View {
        VoiceBoxChangelogView()
            .voiceBoxTheme(shared.configuration?.theme ?? Theme())
            .environment(\.voiceBoxLocalization, shared.configuration?.localization ?? Localization())
    }

    /// View for submitting a new feature request
    /// Use this in a sheet or navigation destination:
    /// ```swift
    /// .sheet(isPresented: $showNewRequest) {
    ///     VoiceBox.NewRequestView()
    /// }
    /// ```
    public static func NewRequestView() -> some View {
        let viewModel = FeedbackViewModel()
        return SubmitFeedbackView(viewModel: viewModel)
            .voiceBoxTheme(shared.configuration?.theme ?? Theme())
            .environment(\.voiceBoxLocalization, shared.configuration?.localization ?? Localization())
    }

    /// Announcement banner that manages its own state
    /// - Parameter configure: Optional closure to customize banner configuration
    /// - Returns: A view that displays announcements when available
    public static func AnnouncementBanner(
        configure: ((inout AnnouncementBannerConfiguration) -> Void)? = nil
    ) -> some View {
        var config = AnnouncementBannerConfiguration()
        configure?(&config)
        return AnnouncementBannerWrapper(config: config)
            .voiceBoxTheme(shared.configuration?.theme ?? Theme())
            .environment(\.voiceBoxLocalization, shared.configuration?.localization ?? Localization())
    }
}

// MARK: - UIKit Support

#if canImport(UIKit)
import UIKit

extension VoiceBox {

    /// UIKit view controller wrapping VoiceBox views
    public static func viewController() -> UIViewController {
        let view = FeedbackView()
        let hostingController = UIHostingController(rootView: view)
        return hostingController
    }
}
#endif

// MARK: - Private Wrapper View

/// Private wrapper that manages announcement state internally
private struct AnnouncementBannerWrapper: View {
    let config: AnnouncementBannerConfiguration

    @ObservedObject private var manager = VoiceBox.announcement
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.voiceBoxTheme) private var theme
    @Environment(\.voiceBoxLocalization) private var l10n

    var body: some View {
        Group {
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
