import Foundation
import SwiftUI

@MainActor
public final class ChangelogViewModel: ObservableObject {

    @Published public var entries: [ChangelogEntry] = []
    @Published public var isLoading = false
    @Published public var error: Error?

    private let api = VoiceBox.shared.api

    public init() {}

    public func loadChangelog() async {
        isLoading = true
        error = nil

        do {
            entries = try await api.fetchChangelog()
        } catch {
            self.error = error
        }

        isLoading = false
    }
}
