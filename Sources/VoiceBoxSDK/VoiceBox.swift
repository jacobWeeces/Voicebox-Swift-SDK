import Foundation
import Supabase

/// VoiceBox SDK for in-app feature requests and voting
@MainActor
public final class VoiceBox {

    // MARK: - Shared Instance

    /// Shared VoiceBox instance
    public static let shared = VoiceBox()

    // MARK: - Properties

    private(set) var client: SupabaseClient?
    private(set) var configuration: Configuration?
    var currentUser: VBUser?
    private(set) var announcementManager: AnnouncementManager?

    /// Whether VoiceBox has been configured
    public var isConfigured: Bool {
        client != nil && configuration != nil
    }

    // MARK: - Initialization

    private init() {}

    // MARK: - Configuration

    /// Configure VoiceBox with your API key
    /// - Parameters:
    ///   - apiKey: Your VoiceBox API key from the dashboard
    ///   - configure: Optional configuration closure
    public static func configure(
        apiKey: String,
        configure: ((inout Configuration) -> Void)? = nil
    ) {
        var config = Configuration(apiKey: apiKey)
        configure?(&config)

        shared.configuration = config
        shared.client = SupabaseClient(
            supabaseURL: config.supabaseURL,
            supabaseKey: config.supabaseAnonKey,
            options: .init(
                auth: .init(
                    autoRefreshToken: false,
                    emitLocalSessionAsInitialSession: true
                ),
                global: .init(
                    headers: ["x-voicebox-api-key": apiKey]
                )
            )
        )

        // Fetch feature settings from server in background
        Task {
            await shared.fetchServerSettings()
        }
    }

    /// Fetch and apply feature settings from server
    private func fetchServerSettings() async {
        do {
            let serverFeatures = try await api.fetchSettings()
            configuration?.features = serverFeatures
            print("[VoiceBox] Loaded settings from server")
        } catch {
            print("[VoiceBox] Failed to fetch settings, using defaults: \(error.localizedDescription)")
            // Keep default allEnabled settings on error
        }
    }

    // MARK: - Announcements

    /// Shared announcement manager instance
    public static var announcement: AnnouncementManager {
        if shared.announcementManager == nil {
            shared.announcementManager = AnnouncementManager()
        }
        return shared.announcementManager!
    }

    /// Refreshes the current announcement from the server
    public static func refreshAnnouncement() async {
        await shared.announcementManager?.refresh()
    }

    // MARK: - User

    /// Update the user's email
    /// - Parameter email: The user's email (or nil to clear)
    public static func setUserEmail(_ email: String?) {
        shared.configuration?.user.email = email
    }

    /// Update the user's name
    /// - Parameter name: The user's display name (or nil to clear)
    public static func setUserName(_ name: String?) {
        shared.configuration?.user.name = name
    }

    // MARK: - Internal

    func ensureConfigured() throws {
        guard isConfigured else {
            throw VoiceBoxError.notConfigured
        }
    }
}

// MARK: - Errors

public enum VoiceBoxError: LocalizedError {
    case notConfigured
    case invalidResponse
    case networkError(Error)
    case serverError(String)

    public var errorDescription: String? {
        switch self {
        case .notConfigured:
            return "VoiceBox has not been configured. Call VoiceBox.configure(apiKey:) first."
        case .invalidResponse:
            return "Invalid response from server."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .serverError(let message):
            return "Server error: \(message)"
        }
    }
}
