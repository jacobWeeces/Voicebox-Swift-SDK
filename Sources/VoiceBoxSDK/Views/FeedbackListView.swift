// packages/voicebox-swift/Sources/VoiceBox/Views/FeedbackListView.swift
import SwiftUI

struct FeedbackListView: View {
    @StateObject private var viewModel = FeedbackViewModel()
    @State private var showingSubmitSheet = false
    @State private var selectedFeedback: Feedback?

    @Environment(\.voiceBoxTheme) private var theme
    @Environment(\.voiceBoxLocalization) private var l10n

    private var config: Configuration? {
        VoiceBox.shared.configuration
    }

    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading && viewModel.feedbackList.isEmpty {
                    ProgressView()
                } else if viewModel.feedbackList.isEmpty && !viewModel.isLoading {
                    emptyState
                } else {
                    contentView
                }
            }
            .navigationTitle(l10n.requestsTab)
            .toolbar {
                if config?.features.submissions.enabled == true {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: { showingSubmitSheet = true }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(theme.accentColor)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingSubmitSheet) {
                SubmitFeedbackView(viewModel: viewModel)
            }
            .sheet(item: $selectedFeedback) { feedback in
                FeedbackDetailView(feedback: feedback, viewModel: viewModel)
            }
            .task {
                await viewModel.loadFeedback()
            }
            .refreshable {
                await viewModel.loadFeedback()
            }
        }
    }

    private var contentView: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(spacing: theme.spacing) {
                    // Announcement banner
                    if let announcement = viewModel.announcement,
                       config?.features.display.announcement == true {
                        AnnouncementBanner(announcement: announcement)
                            .padding(.horizontal)
                    }

                    // Search bar
                    if config?.features.display.searchBar == true {
                        searchBar
                            .padding(.horizontal)
                    }

                    // Status filter
                    statusFilter
                        .padding(.horizontal)

                    // Feedback list
                    LazyVStack(spacing: theme.spacing) {
                        ForEach(viewModel.filteredFeedback) { feedback in
                            FeedbackCard(feedback: feedback) {
                                Task {
                                    await viewModel.toggleVote(for: feedback)
                                }
                            }
                            .onTapGesture {
                                selectedFeedback = feedback
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .background(theme.backgroundColor)

            // Floating action button for submitting new feedback
            if config?.features.submissions.enabled == true {
                Button(action: { showingSubmitSheet = true }) {
                    Image(systemName: "plus")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                        .background(theme.accentColor)
                        .clipShape(Circle())
                        .shadow(color: theme.accentColor.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
            }
        }
    }

    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(theme.secondaryTextColor)

            TextField(l10n.searchPlaceholder, text: $viewModel.searchText)
                .textFieldStyle(.plain)
        }
        .padding(12)
        .background(theme.secondaryBackgroundColor)
        .cornerRadius(10)
    }

    private var statusFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                filterChip(title: "All", status: nil)

                ForEach(FeedbackStatus.allCases, id: \.self) { status in
                    filterChip(title: l10n.status(status), status: status)
                }
            }
        }
    }

    private func filterChip(title: String, status: FeedbackStatus?) -> some View {
        Button(action: {
            viewModel.selectedStatus = status
        }) {
            Text(title)
                .font(.caption.bold())
                .foregroundColor(viewModel.selectedStatus == status ? .white : theme.primaryTextColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(viewModel.selectedStatus == status ? theme.accentColor : theme.secondaryBackgroundColor)
                .cornerRadius(16)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "lightbulb")
                .font(.system(size: 60))
                .foregroundColor(theme.tertiaryTextColor)

            Text(l10n.noRequestsTitle)
                .font(theme.titleFont)
                .foregroundColor(theme.primaryTextColor)

            Text(l10n.noRequestsMessage)
                .font(theme.bodyFont)
                .foregroundColor(theme.secondaryTextColor)
                .multilineTextAlignment(.center)

            if config?.features.submissions.enabled == true {
                Button(action: { showingSubmitSheet = true }) {
                    Text(l10n.submitButton)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(theme.accentColor)
                        .cornerRadius(10)
                }
                .padding(.top)
            }
        }
        .padding()
    }
}
