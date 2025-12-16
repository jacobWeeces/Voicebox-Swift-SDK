// packages/voicebox-swift/Sources/VoiceBox/Views/RoadmapView.swift
import SwiftUI

struct VoiceBoxRoadmapView: View {
    @StateObject private var viewModel = RoadmapViewModel()

    @Environment(\.voiceBoxTheme) private var theme
    @Environment(\.voiceBoxLocalization) private var l10n

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.items.isEmpty {
                    ProgressView()
                } else if viewModel.items.isEmpty && !viewModel.isLoading {
                    emptyState
                } else {
                    contentView
                }
            }
            .navigationTitle(l10n.roadmapTab)
            .task {
                await viewModel.loadRoadmap()
            }
            .refreshable {
                await viewModel.loadRoadmap()
            }
        }
    }

    private var contentView: some View {
        ScrollView {
            VStack(spacing: 20) {
                // In Progress section (show first - most relevant)
                if !viewModel.inProgressItems.isEmpty {
                    roadmapSection(
                        title: l10n.roadmapInProgress,
                        icon: "hammer.fill",
                        items: viewModel.inProgressItems,
                        color: theme.statusColors.inProgress
                    )
                }

                // Planned section
                roadmapSection(
                    title: l10n.roadmapPlanned,
                    icon: "calendar.badge.clock",
                    items: viewModel.plannedItems,
                    color: theme.statusColors.planned
                )

                // Completed section
                if !viewModel.completedItems.isEmpty {
                    roadmapSection(
                        title: l10n.roadmapCompleted,
                        icon: "checkmark.seal.fill",
                        items: viewModel.completedItems,
                        color: theme.statusColors.completed
                    )
                }
            }
            .padding()
        }
        .background(theme.backgroundColor)
    }

    private func roadmapSection(title: String, icon: String, items: [RoadmapItem], color: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section header
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(color)

                Text(title)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(theme.primaryTextColor)

                Text("\(items.count)")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(color)
                    .clipShape(Capsule())

                Spacer()
            }
            .padding(.horizontal, 4)

            // Section items
            if items.isEmpty {
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: "tray")
                            .font(.system(size: 24))
                            .foregroundColor(theme.tertiaryTextColor.opacity(0.5))
                        Text("Nothing here yet")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(theme.tertiaryTextColor)
                    }
                    .padding(.vertical, 20)
                    Spacer()
                }
                .background(color.opacity(0.05))
                .cornerRadius(12)
            } else {
                VStack(spacing: 10) {
                    ForEach(items) { item in
                        roadmapCard(item: item, color: color)
                    }
                }
            }
        }
    }

    private func roadmapCard(item: RoadmapItem, color: Color) -> some View {
        HStack(spacing: 0) {
            // Colored accent bar
            Rectangle()
                .fill(color)
                .frame(width: 4)

            // Content
            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(theme.primaryTextColor)
                    .lineLimit(2)

                if let description = item.description, !description.isEmpty {
                    Text(description)
                        .font(.system(size: 13))
                        .foregroundColor(theme.secondaryTextColor)
                        .lineLimit(2)
                }

                if let voteCount = item.voteCount, voteCount > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 12))
                        Text("\(voteCount)")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundColor(color)
                    .padding(.top, 2)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(theme.secondaryBackgroundColor)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(theme.accentColor.opacity(0.1))
                    .frame(width: 100, height: 100)

                Image(systemName: "map.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [theme.accentColor, theme.accentColor.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }

            VStack(spacing: 8) {
                Text(l10n.noRoadmapTitle)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(theme.primaryTextColor)

                Text(l10n.noRoadmapMessage)
                    .font(.system(size: 15))
                    .foregroundColor(theme.secondaryTextColor)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(32)
    }
}
