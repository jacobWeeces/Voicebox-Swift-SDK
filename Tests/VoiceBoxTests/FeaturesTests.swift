import XCTest
@testable import VoiceBox

final class FeaturesTests: XCTestCase {

    func testFullPreset() {
        let features = Features.full

        XCTAssertTrue(features.tabs.requests)
        XCTAssertTrue(features.tabs.roadmap)
        XCTAssertTrue(features.tabs.changelog)
        XCTAssertTrue(features.voting.enabled)
        XCTAssertTrue(features.comments.enabled)
    }

    func testMinimalPreset() {
        let features = Features.minimal

        XCTAssertTrue(features.tabs.requests)
        XCTAssertFalse(features.tabs.roadmap)
        XCTAssertFalse(features.tabs.changelog)
        XCTAssertTrue(features.voting.enabled)
        XCTAssertFalse(features.comments.enabled)
    }

    func testReadOnlyPreset() {
        let features = Features.readOnly

        XCTAssertFalse(features.submissions.enabled)
        XCTAssertFalse(features.voting.enabled)
        XCTAssertFalse(features.comments.enabled)
    }

    func testDisableFeatures() {
        var features = Features.full
        features.disable(.comments, .images, .roadmapTab)

        XCTAssertFalse(features.comments.enabled)
        XCTAssertFalse(features.submissions.images)
        XCTAssertFalse(features.tabs.roadmap)
    }

    func testEnableFeatures() {
        var features = Features.minimal
        features.enable(.roadmapTab, .comments)

        XCTAssertTrue(features.tabs.roadmap)
        XCTAssertTrue(features.comments.enabled)
    }
}
