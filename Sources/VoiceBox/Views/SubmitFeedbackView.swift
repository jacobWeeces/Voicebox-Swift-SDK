// packages/voicebox-swift/Sources/VoiceBox/Views/SubmitFeedbackView.swift
import SwiftUI

struct SubmitFeedbackView: View {
    @ObservedObject var viewModel: FeedbackViewModel

    @State private var title = ""
    @State private var description = ""
    @State private var showError = false
    @State private var errorMessage = ""

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
                    // Title field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title")
                            .font(theme.titleFont)
                            .foregroundColor(theme.primaryTextColor)

                        TextField(l10n.titlePlaceholder, text: $title)
                            .textFieldStyle(.plain)
                            .padding(12)
                            .background(theme.secondaryBackgroundColor)
                            .cornerRadius(10)
                    }

                    // Description field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(theme.titleFont)
                            .foregroundColor(theme.primaryTextColor)

                        TextField(l10n.descriptionPlaceholder, text: $description, axis: .vertical)
                            .textFieldStyle(.plain)
                            .padding(12)
                            .background(theme.secondaryBackgroundColor)
                            .cornerRadius(10)
                            .lineLimit(5...10)
                    }

                    // Optional email field
                    if config?.features.submissions.requireEmail == true {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(theme.titleFont)
                                .foregroundColor(theme.primaryTextColor)

                            TextField(l10n.emailPlaceholder, text: .constant(config?.user.email ?? ""))
                                .textFieldStyle(.plain)
                                .padding(12)
                                .background(theme.secondaryBackgroundColor)
                                .cornerRadius(10)
                        }
                    }

                    // Helper text
                    Text("Share your feature ideas and help us improve the app!")
                        .font(theme.captionFont)
                        .foregroundColor(theme.secondaryTextColor)
                        .padding(.top, 8)

                    Spacer()
                }
                .padding()
            }
            .background(theme.backgroundColor)
            .navigationTitle(l10n.newRequestLabel)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(l10n.cancelButton) {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button(action: submitFeedback) {
                        if viewModel.isSubmitting {
                            ProgressView()
                        } else {
                            Text(l10n.submitButton)
                                .bold()
                                .foregroundColor(theme.accentColor)
                        }
                    }
                    .disabled(title.isEmpty || description.isEmpty || viewModel.isSubmitting)
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }

    private func submitFeedback() {
        guard !title.isEmpty else {
            errorMessage = l10n.errorTitleRequired
            showError = true
            return
        }

        guard !description.isEmpty else {
            errorMessage = l10n.errorDescriptionRequired
            showError = true
            return
        }

        Task {
            let success = await viewModel.submitFeedback(
                title: title,
                description: description
            )

            if success {
                dismiss()
            } else {
                errorMessage = viewModel.error?.localizedDescription ?? l10n.errorTitle
                showError = true
            }
        }
    }
}
