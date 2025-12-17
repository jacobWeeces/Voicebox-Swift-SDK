import Foundation
import SwiftUI

/// VoiceBox configuration
public struct Configuration {

    // MARK: - API

    /// Your VoiceBox API key
    public let apiKey: String

    /// Supabase URL (defaults to VoiceBox cloud)
    public var supabaseURL: URL = URL(string: "https://pvpeiarjdwcuatkwzjcw.supabase.co")!

    /// Supabase anonymous key
    public var supabaseAnonKey: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB2cGVpYXJqZHdjdWF0a3d6amN3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUyOTMwNTIsImV4cCI6MjA4MDg2OTA1Mn0.4HdNECKVB4ucqlH2jgXJfmN5a17Sx4aclL3mraXRC8c"

    // MARK: - User

    /// User configuration
    public var user = UserConfiguration()

    // MARK: - Features

    /// Feature toggles (fetched from server)
    public var features = Features.allEnabled

    // MARK: - Theme

    /// Visual theme
    public var theme = Theme()

    // MARK: - Localization

    /// UI string overrides
    public var localization = Localization()

    // MARK: - Init

    public init(apiKey: String) {
        self.apiKey = apiKey
    }
}

// MARK: - User Configuration

public struct UserConfiguration {
    /// User's email (optional, for notifications)
    public var email: String?

    /// User's display name (optional)
    public var name: String?

    /// User's payment information (for segmentation)
    public var payment: Payment = .none

    /// Additional metadata
    public var metadata: [String: String] = [:]

    public init() {}
}

// MARK: - Payment

public enum Payment {
    case none
    case weekly(Double)
    case monthly(Double)
    case yearly(Double)
    case lifetime(Double)

    var interval: String {
        switch self {
        case .none: return "none"
        case .weekly: return "weekly"
        case .monthly: return "monthly"
        case .yearly: return "yearly"
        case .lifetime: return "lifetime"
        }
    }

    var amount: Double? {
        switch self {
        case .none: return nil
        case .weekly(let amount), .monthly(let amount),
             .yearly(let amount), .lifetime(let amount):
            return amount
        }
    }
}
