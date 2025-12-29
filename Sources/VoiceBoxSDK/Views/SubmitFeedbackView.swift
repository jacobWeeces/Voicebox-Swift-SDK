// packages/voicebox-swift/Sources/VoiceBox/Views/SubmitFeedbackView.swift
import SwiftUI

struct SubmitFeedbackView: View {
    @ObservedObject var viewModel: FeedbackViewModel

    @State private var title = ""
    @State private var description = ""
    @State private var email = ""
    @State private var shareEmail = true
    @State private var showEmailPrompt = false
    @State private var showError = false
    @State private var errorMessage = ""

    @Environment(\.dismiss) private var dismiss
    @Environment(\.voiceBoxTheme) private var theme
    @Environment(\.voiceBoxLocalization) private var l10n

    private var config: Configuration? {
        VoiceBox.shared.configuration
    }

    // Check if user has already made email choice
    private var hasEmailPreference: Bool {
        UserDefaults.standard.bool(forKey: "voicebox_email_preference_set")
    }

    // Get stored email if any
    private var storedEmail: String? {
        UserDefaults.standard.string(forKey: "voicebox_user_email")
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
                    Button(action: handleSubmitTapped) {
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
            .sheet(isPresented: $showEmailPrompt) {
                emailPromptSheet
            }
        }
        .onAppear {
            // Pre-fill email if we have it stored
            if let stored = storedEmail {
                email = stored
            } else if let configEmail = config?.user.email {
                email = configEmail
            }
        }
    }

    private var emailPromptSheet: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "envelope.badge.fill")
                    .font(.system(size: 50))
                    .foregroundColor(theme.accentColor)

                VStack(spacing: 8) {
                    Text("Share your email?")
                        .font(.title2.bold())
                        .foregroundColor(theme.primaryTextColor)

                    Text("Get notified when we respond to your feedback or update its status.")
                        .font(.subheadline)
                        .foregroundColor(theme.secondaryTextColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                VStack(spacing: 16) {
                    Toggle(isOn: $shareEmail) {
                        Text("Share my email")
                            .font(.body)
                            .foregroundColor(theme.primaryTextColor)
                    }
                    .tint(theme.accentColor)

                    if shareEmail {
                        TextField("your@email.com", text: $email)
                            .textFieldStyle(.plain)
                            #if os(iOS)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                            #endif
                            .padding(12)
                            .background(theme.secondaryBackgroundColor)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(theme.secondaryBackgroundColor.opacity(0.5))
                .cornerRadius(12)
                .padding(.horizontal)

                Spacer()

                Button {
                    saveEmailPreferenceAndSubmit()
                } label: {
                    Text("Continue")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(theme.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(shareEmail && email.isEmpty)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .background(theme.backgroundColor)
            .navigationTitle("Before you submit")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showEmailPrompt = false
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }

    private func handleSubmitTapped() {
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

        // If user hasn't set email preference yet, show the prompt
        if !hasEmailPreference {
            showEmailPrompt = true
        } else {
            submitFeedback()
        }
    }

    private func saveEmailPreferenceAndSubmit() {
        // Save preference
        UserDefaults.standard.set(true, forKey: "voicebox_email_preference_set")

        if shareEmail && !email.isEmpty {
            // Save email and update SDK config
            UserDefaults.standard.set(email, forKey: "voicebox_user_email")
            VoiceBox.setUserEmail(email)
        } else {
            // User chose not to share email
            UserDefaults.standard.removeObject(forKey: "voicebox_user_email")
            VoiceBox.setUserEmail(nil)
        }

        showEmailPrompt = false
        submitFeedback()
    }

    private func submitFeedback() {
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
