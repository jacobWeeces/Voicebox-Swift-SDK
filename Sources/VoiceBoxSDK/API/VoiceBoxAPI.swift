import Foundation
import Supabase

/// API client for VoiceBox backend operations
@MainActor
public final class VoiceBoxAPI {

    private let voicebox: VoiceBox

    init(voicebox: VoiceBox = .shared) {
        self.voicebox = voicebox
    }

    private var client: SupabaseClient {
        get throws {
            guard let client = voicebox.client else {
                throw VoiceBoxError.notConfigured
            }
            return client
        }
    }

    // MARK: - User

    /// Get or create user by device ID
    func getOrCreateUser() async throws -> VBUser {
        let client = try client
        let config = voicebox.configuration!

        let deviceId = getDeviceId()

        struct UserParams: Encodable {
            let p_device_id: String
            let p_email: String?
            let p_name: String?
            let p_payment_amount: Double?
            let p_payment_interval: String?
        }

        let params = UserParams(
            p_device_id: deviceId,
            p_email: config.user.email,
            p_name: config.user.name,
            p_payment_amount: config.user.payment.amount,
            p_payment_interval: config.user.payment.interval
        )

        let userId: UUID = try await client.rpc("get_or_create_user", params: params).execute().value

        // Fetch full user
        let user: VBUser = try await client
            .from("users")
            .select()
            .eq("id", value: userId.uuidString)
            .single()
            .execute()
            .value

        return user
    }

    private func getDeviceId() -> String {
        let key = "voicebox_device_id"
        if let existing = UserDefaults.standard.string(forKey: key) {
            return existing
        }
        let newId = UUID().uuidString
        UserDefaults.standard.set(newId, forKey: key)
        return newId
    }

    // MARK: - Feedback

    /// Fetch feedback list
    func fetchFeedback(
        status: FeedbackStatus? = nil,
        limit: Int = 50,
        offset: Int = 0
    ) async throws -> [Feedback] {
        let client = try client

        guard let user = voicebox.currentUser else {
            throw VoiceBoxError.notConfigured
        }

        struct FeedbackParams: Encodable {
            let p_user_id: UUID
            let p_status: String?
            let p_limit: Int
            let p_offset: Int
        }

        let params = FeedbackParams(
            p_user_id: user.id,
            p_status: status?.rawValue,
            p_limit: limit,
            p_offset: offset
        )

        let feedback: [Feedback] = try await client
            .rpc("get_feedback_list", params: params)
            .execute()
            .value

        return feedback
    }

    /// Submit new feedback
    func submitFeedback(title: String, description: String, images: [String] = []) async throws -> UUID {
        let client = try client

        guard let user = voicebox.currentUser else {
            throw VoiceBoxError.notConfigured
        }

        struct SubmitParams: Encodable {
            let p_user_id: UUID
            let p_title: String
            let p_description: String
            let p_images: [String]
        }

        let params = SubmitParams(
            p_user_id: user.id,
            p_title: title,
            p_description: description,
            p_images: images
        )

        let feedbackId: UUID = try await client
            .rpc("submit_feedback", params: params)
            .execute()
            .value

        return feedbackId
    }

    /// Toggle vote on feedback
    func toggleVote(feedbackId: UUID) async throws -> Bool {
        let client = try client

        guard let user = voicebox.currentUser else {
            throw VoiceBoxError.notConfigured
        }

        struct VoteParams: Encodable {
            let p_user_id: UUID
            let p_feedback_id: UUID
        }

        let params = VoteParams(
            p_user_id: user.id,
            p_feedback_id: feedbackId
        )

        let voted: Bool = try await client
            .rpc("toggle_vote", params: params)
            .execute()
            .value

        return voted
    }

    // MARK: - Comments

    /// Fetch comments for feedback
    func fetchComments(feedbackId: UUID) async throws -> [Comment] {
        let client = try client

        let comments: [Comment] = try await client
            .from("comments")
            .select("""
                *,
                developers(name, avatar_url)
            """)
            .eq("feedback_id", value: feedbackId.uuidString)
            .order("created_at", ascending: true)
            .execute()
            .value

        return comments
    }

    /// Add comment to feedback
    func addComment(feedbackId: UUID, body: String, images: [String] = []) async throws {
        let client = try client

        guard let user = voicebox.currentUser else {
            throw VoiceBoxError.notConfigured
        }

        struct CommentInsert: Encodable {
            let feedback_id: UUID
            let user_id: UUID
            let body: String
            let images: [String]
        }

        let comment = CommentInsert(
            feedback_id: feedbackId,
            user_id: user.id,
            body: body,
            images: images
        )

        try await client
            .from("comments")
            .insert(comment)
            .execute()
    }

    // MARK: - Announcement

    /// Fetch active announcement
    func fetchAnnouncement() async throws -> Announcement? {
        let client = try client

        let announcements: [Announcement] = try await client
            .from("announcements")
            .select()
            .eq("active", value: true)
            .limit(1)
            .execute()
            .value

        return announcements.first
    }

    // MARK: - Changelog

    /// Fetch published changelog entries
    func fetchChangelog(limit: Int = 20) async throws -> [ChangelogEntry] {
        let client = try client

        let entries: [ChangelogEntry] = try await client
            .from("changelog")
            .select()
            .eq("published", value: true)
            .order("published_at", ascending: false)
            .limit(limit)
            .execute()
            .value

        return entries
    }

    // MARK: - Roadmap

    /// Fetch visible roadmap items
    func fetchRoadmap() async throws -> [RoadmapItem] {
        let client = try client

        let items: [RoadmapItem] = try await client
            .from("roadmap_items")
            .select("""
                *,
                feedback(vote_count)
            """)
            .eq("visible", value: true)
            .order("position", ascending: true)
            .execute()
            .value

        return items
    }

    // MARK: - Image Upload

    /// Maximum allowed image size in bytes (10MB)
    private static let maxImageSizeBytes = 10 * 1024 * 1024

    /// Upload image and return public URL
    /// - Parameters:
    ///   - data: Image data (JPEG, PNG, HEIC)
    ///   - bucket: Storage bucket name
    /// - Throws: `VoiceBoxError.imageTooLarge` if image exceeds 10MB
    /// - Returns: Public URL of the uploaded image
    func uploadImage(data: Data, bucket: String = "feedback-images") async throws -> String {
        // Validate image size
        let maxSize = Self.maxImageSizeBytes
        if data.count > maxSize {
            let actualMB = Double(data.count) / (1024 * 1024)
            let maxMB = Double(maxSize) / (1024 * 1024)
            throw VoiceBoxError.imageTooLarge(actualMB: actualMB, maxMB: maxMB)
        }

        let client = try client

        let fileName = "\(UUID().uuidString).jpg"
        let path = fileName

        try await client.storage
            .from(bucket)
            .upload(path: path, file: data, options: .init(contentType: "image/jpeg"))

        let publicURL = try client.storage
            .from(bucket)
            .getPublicURL(path: path)

        return publicURL.absoluteString
    }
}

// MARK: - VoiceBox Extension

extension VoiceBox {
    /// API client for backend operations
    public var api: VoiceBoxAPI {
        VoiceBoxAPI(voicebox: self)
    }
}
