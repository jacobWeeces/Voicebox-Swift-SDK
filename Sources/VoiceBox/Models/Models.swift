import Foundation

// MARK: - User

public struct VBUser: Codable, Identifiable, Sendable {
    public let id: UUID
    public let projectId: UUID
    public let deviceId: String
    public var email: String?
    public var name: String?
    public var paymentAmount: Double?
    public var paymentInterval: String?
    public var metadata: [String: String]?
    public let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case projectId = "project_id"
        case deviceId = "device_id"
        case email
        case name
        case paymentAmount = "payment_amount"
        case paymentInterval = "payment_interval"
        case metadata
        case createdAt = "created_at"
    }
}

// MARK: - Feedback

public struct Feedback: Codable, Identifiable, Sendable {
    public let id: UUID
    public let projectId: UUID
    public let userId: UUID
    public let title: String
    public let description: String
    public var status: FeedbackStatus
    public var voteCount: Int
    public var images: [String]
    public let createdAt: Date
    public var userVoted: Bool?
    public var commentCount: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case projectId = "project_id"
        case userId = "user_id"
        case title
        case description
        case status
        case voteCount = "vote_count"
        case images
        case createdAt = "created_at"
        case userVoted = "user_voted"
        case commentCount = "comment_count"
    }
}

// MARK: - Feedback Status

public enum FeedbackStatus: String, Codable, CaseIterable, Sendable {
    case open
    case underReview = "under_review"
    case planned
    case inProgress = "in_progress"
    case completed
    case declined
}

// MARK: - Comment

public struct Comment: Codable, Identifiable, Sendable {
    public let id: UUID
    public let feedbackId: UUID
    public let userId: UUID?
    public let developerId: UUID?
    public let body: String
    public var images: [String]
    public let createdAt: Date

    // Joined data
    public var developerName: String?
    public var developerAvatar: String?

    public var isDeveloper: Bool {
        developerId != nil
    }

    enum CodingKeys: String, CodingKey {
        case id
        case feedbackId = "feedback_id"
        case userId = "user_id"
        case developerId = "developer_id"
        case body
        case images
        case createdAt = "created_at"
        case developerName = "developer_name"
        case developerAvatar = "developer_avatar"
    }
}

// MARK: - Announcement

public struct Announcement: Codable, Identifiable, Sendable {
    public let id: UUID
    public let projectId: UUID
    public let title: String
    public let body: String
    public let active: Bool
    public let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case projectId = "project_id"
        case title
        case body
        case active
        case createdAt = "created_at"
    }
}

// MARK: - Changelog Entry

public struct ChangelogEntry: Codable, Identifiable, Sendable {
    public let id: UUID
    public let projectId: UUID
    public let title: String
    public let body: String
    public var version: String?
    public let publishedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case projectId = "project_id"
        case title
        case body
        case version
        case publishedAt = "published_at"
    }
}

// MARK: - Roadmap Item

public struct RoadmapItem: Codable, Identifiable, Sendable {
    public let id: UUID
    public let projectId: UUID
    public let feedbackId: UUID?
    public let title: String
    public var description: String?
    public var stage: RoadmapColumn
    public var position: Int
    public let createdAt: Date

    // Joined data
    public var voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case projectId = "project_id"
        case feedbackId = "feedback_id"
        case title
        case description
        case stage
        case position
        case createdAt = "created_at"
        case voteCount = "vote_count"
    }
}

// MARK: - Roadmap Column

public enum RoadmapColumn: String, Codable, CaseIterable, Sendable {
    case planned
    case inProgress = "in_progress"
    case completed
}
