import Foundation
import SwiftUI

@MainActor
public final class RoadmapViewModel: ObservableObject {

    @Published public var items: [RoadmapItem] = []
    @Published public var isLoading = false
    @Published public var error: Error?

    private let api = VoiceBox.shared.api

    public var plannedItems: [RoadmapItem] {
        items.filter { $0.stage == .planned }
    }

    public var inProgressItems: [RoadmapItem] {
        items.filter { $0.stage == .inProgress }
    }

    public var completedItems: [RoadmapItem] {
        items.filter { $0.stage == .completed }
    }

    public init() {}

    public func loadRoadmap() async {
        isLoading = true
        error = nil

        do {
            items = try await api.fetchRoadmap()
        } catch {
            self.error = error
        }

        isLoading = false
    }
}
