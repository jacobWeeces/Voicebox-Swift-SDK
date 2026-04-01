import Foundation
import SwiftUI

@MainActor
public final class FeedbackViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published public var feedbackList: [Feedback] = []
    @Published public var selectedFeedback: Feedback?
    @Published public var comments: [Comment] = []
    @Published public var announcement: Announcement?

    @Published public var isLoading = false
    @Published public var isLoadingComments = false
    @Published public var isSubmitting = false
    @Published public var error: Error?

    @Published public var searchText = ""
    @Published public var selectedStatus: FeedbackStatus?

    // MARK: - Private

    private let api = VoiceBox.shared.api

    // MARK: - Computed

    public var filteredFeedback: [Feedback] {
        var result = feedbackList

        if let status = selectedStatus {
            result = result.filter { $0.status == status }
        }

        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }

        return result
    }

    // MARK: - Init

    public init() {}

    // MARK: - Actions

    public func loadFeedback() async {
        isLoading = true
        error = nil

        do {
            // Ensure user exists
            if VoiceBox.shared.currentUser == nil {
                VoiceBox.shared.currentUser = try await api.getOrCreateUser()
            }

            print("[VoiceBox] Loading feedback for user: \(VoiceBox.shared.currentUser?.id.uuidString ?? "nil")")

            async let feedbackTask = api.fetchFeedback()
            async let announcementTask = api.fetchAnnouncement()

            let (feedback, announcement) = try await (feedbackTask, announcementTask)

            print("[VoiceBox] Loaded \(feedback.count) feedback items")

            self.feedbackList = feedback
            self.announcement = announcement
        } catch {
            print("[VoiceBox] Error loading feedback: \(error)")
            self.error = error
        }

        isLoading = false
    }

    public func loadComments(for feedback: Feedback) async {
        isLoadingComments = true

        do {
            comments = try await api.fetchComments(feedbackId: feedback.id)
        } catch {
            self.error = error
        }

        isLoadingComments = false
    }

    public func submitFeedback(title: String, description: String, images: [Data] = []) async -> Bool {
        isSubmitting = true
        error = nil

        do {
            // Ensure user exists
            if VoiceBox.shared.currentUser == nil {
                VoiceBox.shared.currentUser = try await api.getOrCreateUser()
            }

            // Upload images first
            var imageUrls: [String] = []
            for imageData in images {
                let url = try await api.uploadImage(data: imageData)
                imageUrls.append(url)
            }

            _ = try await api.submitFeedback(
                title: title,
                description: description,
                images: imageUrls
            )

            // Refresh list
            await loadFeedback()

            isSubmitting = false
            return true
        } catch {
            self.error = error
            isSubmitting = false
            return false
        }
    }

    public func toggleVote(for feedback: Feedback) async {
        do {
            let voted = try await api.toggleVote(feedbackId: feedback.id)

            // Update local state
            if let index = feedbackList.firstIndex(where: { $0.id == feedback.id }) {
                feedbackList[index].userVoted = voted
                feedbackList[index].voteCount += voted ? 1 : -1
            }
        } catch {
            self.error = error
        }
    }

    public func addComment(to feedback: Feedback, body: String, images: [Data] = []) async -> Bool {
        do {
            var imageUrls: [String] = []
            for imageData in images {
                let url = try await api.uploadImage(data: imageData, bucket: "comment-images")
                imageUrls.append(url)
            }

            try await api.addComment(
                feedbackId: feedback.id,
                body: body,
                images: imageUrls
            )

            // Refresh comments
            await loadComments(for: feedback)

            return true
        } catch {
            self.error = error
            return false
        }
    }
}
