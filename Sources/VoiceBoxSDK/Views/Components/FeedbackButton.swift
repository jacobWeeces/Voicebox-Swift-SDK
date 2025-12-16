import SwiftUI

// MARK: - Feedback Button Style

/// Style options for the feedback button
public enum FeedbackButtonStyle {
    /// Standard button with text
    case standard
    /// Pill-shaped button
    case pill
    /// Floating action button (circular, icon only)
    case floating
    /// Text-only button
    case text
}

// MARK: - Internal View

/// Internal view implementation for the feedback button
struct FeedbackButtonView<Label: View>: View {

    private let style: FeedbackButtonStyle
    private let label: Label

    @State private var showingSubmitSheet = false
    @StateObject private var viewModel = FeedbackViewModel()

    @Environment(\.voiceBoxTheme) private var theme
    @Environment(\.voiceBoxLocalization) private var l10n

    /// Create a feedback button with a custom label
    init(@ViewBuilder label: () -> Label) {
        self.style = .standard
        self.label = label()
    }

    /// Create a feedback button with default styling
    init(style: FeedbackButtonStyle = .standard) where Label == EmptyView {
        self.style = style
        self.label = EmptyView()
    }

    var body: some View {
        Button(action: { showingSubmitSheet = true }) {
            buttonContent
        }
        .sheet(isPresented: $showingSubmitSheet) {
            SubmitFeedbackView(viewModel: viewModel)
                .voiceBoxTheme(theme)
                .environment(\.voiceBoxLocalization, l10n)
        }
    }

    @ViewBuilder
    private var buttonContent: some View {
        if Label.self != EmptyView.self {
            // Custom label provided
            label
        } else {
            // Default styling based on style
            switch style {
            case .standard:
                HStack(spacing: 8) {
                    Image(systemName: "lightbulb")
                    Text(l10n.submitButton)
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(theme.accentColor)
                .cornerRadius(10)

            case .pill:
                HStack(spacing: 8) {
                    Image(systemName: "lightbulb.fill")
                    Text(l10n.submitButton)
                }
                .font(.subheadline.bold())
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(theme.accentColor)
                .clipShape(Capsule())

            case .floating:
                Image(systemName: "plus")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(theme.accentColor)
                    .clipShape(Circle())
                    .shadow(color: theme.accentColor.opacity(0.4), radius: 8, x: 0, y: 4)

            case .text:
                HStack(spacing: 6) {
                    Image(systemName: "lightbulb")
                    Text(l10n.submitButton)
                }
                .font(.body)
                .foregroundColor(theme.accentColor)
            }
        }
    }
}

// MARK: - VoiceBox Extension

extension VoiceBox {

    /// A button that opens the feedback submission form
    ///
    /// Place this anywhere in your app to let users submit feedback:
    /// ```swift
    /// // In a settings screen
    /// VoiceBox.FeedbackButton()
    ///
    /// // As a floating action button
    /// VoiceBox.FeedbackButton(style: .floating)
    ///
    /// // With custom styling
    /// VoiceBox.FeedbackButton {
    ///     Text("Share an idea")
    ///         .foregroundColor(.blue)
    /// }
    /// ```
    public static func FeedbackButton(style: FeedbackButtonStyle = .standard) -> some View {
        FeedbackButtonView<EmptyView>(style: style)
            .voiceBoxTheme(shared.configuration?.theme ?? Theme())
            .environment(\.voiceBoxLocalization, shared.configuration?.localization ?? Localization())
    }

    /// A feedback button with a custom label
    public static func FeedbackButton<Label: View>(@ViewBuilder label: () -> Label) -> some View {
        FeedbackButtonView(label: label)
            .voiceBoxTheme(shared.configuration?.theme ?? Theme())
            .environment(\.voiceBoxLocalization, shared.configuration?.localization ?? Localization())
    }
}

// MARK: - Preview

#Preview("Standard") {
    FeedbackButtonView<EmptyView>(style: .standard)
}

#Preview("Pill") {
    FeedbackButtonView<EmptyView>(style: .pill)
}

#Preview("Floating") {
    FeedbackButtonView<EmptyView>(style: .floating)
}

#Preview("Text") {
    FeedbackButtonView<EmptyView>(style: .text)
}
