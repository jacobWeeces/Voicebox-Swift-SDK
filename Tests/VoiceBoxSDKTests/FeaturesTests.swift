import XCTest
@testable import VoiceBoxSDK

final class FeaturesTests: XCTestCase {

    func testAllEnabledDefault() {
        let features = Features.allEnabled

        // Tabs
        XCTAssertTrue(features.tabs.requests)
        XCTAssertTrue(features.tabs.roadmap)
        XCTAssertTrue(features.tabs.changelog)

        // Submissions
        XCTAssertTrue(features.submissions.enabled)
        XCTAssertTrue(features.submissions.images)
        XCTAssertTrue(features.submissions.anonymous)
        XCTAssertFalse(features.submissions.requireEmail)

        // Voting
        XCTAssertTrue(features.voting.enabled)
        XCTAssertTrue(features.voting.allowUnvote)
        XCTAssertTrue(features.voting.showCounts)

        // Comments
        XCTAssertTrue(features.comments.enabled)
        XCTAssertTrue(features.comments.images)
        XCTAssertTrue(features.comments.developerBadge)

        // Display
        XCTAssertTrue(features.display.statusBadges)
        XCTAssertTrue(features.display.userAvatars)
        XCTAssertTrue(features.display.announcement)
        XCTAssertTrue(features.display.searchBar)
        XCTAssertTrue(features.display.timestamps)

        // Notifications
        XCTAssertTrue(features.notifications.optInPrompt)
        XCTAssertTrue(features.notifications.onStatusChange)
    }

    func testCustomInitialization() {
        let features = Features(
            tabs: .init(requests: true, roadmap: false, changelog: false),
            submissions: .init(enabled: true, images: false, anonymous: false, requireEmail: true),
            voting: .init(enabled: false, allowUnvote: false, showCounts: false),
            comments: .init(enabled: false, images: false, developerBadge: false),
            display: .init(statusBadges: true, userAvatars: false, announcement: false, searchBar: true, timestamps: false),
            notifications: .init(optInPrompt: false, onStatusChange: false)
        )

        XCTAssertTrue(features.tabs.requests)
        XCTAssertFalse(features.tabs.roadmap)
        XCTAssertFalse(features.voting.enabled)
        XCTAssertTrue(features.submissions.requireEmail)
        XCTAssertFalse(features.display.userAvatars)
    }

    func testJSONDecoding() throws {
        let json = """
        {
            "tabs": {"requests": true, "roadmap": false, "changelog": true},
            "submissions": {"enabled": true, "images": false, "anonymous": true, "requireEmail": false},
            "voting": {"enabled": true, "allowUnvote": false, "showCounts": true},
            "comments": {"enabled": false, "images": false, "developerBadge": true},
            "display": {"statusBadges": true, "userAvatars": false, "announcement": true, "searchBar": false, "timestamps": true},
            "notifications": {"optInPrompt": false, "onStatusChange": true}
        }
        """.data(using: .utf8)!

        let features = try JSONDecoder().decode(Features.self, from: json)

        XCTAssertTrue(features.tabs.requests)
        XCTAssertFalse(features.tabs.roadmap)
        XCTAssertTrue(features.tabs.changelog)
        XCTAssertFalse(features.submissions.images)
        XCTAssertFalse(features.voting.allowUnvote)
        XCTAssertFalse(features.comments.enabled)
        XCTAssertTrue(features.comments.developerBadge)
        XCTAssertFalse(features.display.userAvatars)
        XCTAssertFalse(features.display.searchBar)
        XCTAssertFalse(features.notifications.optInPrompt)
        XCTAssertTrue(features.notifications.onStatusChange)
    }

    func testMutability() {
        var features = Features.allEnabled

        features.tabs.roadmap = false
        features.submissions.enabled = false
        features.voting.showCounts = false

        XCTAssertFalse(features.tabs.roadmap)
        XCTAssertFalse(features.submissions.enabled)
        XCTAssertFalse(features.voting.showCounts)
    }
}
