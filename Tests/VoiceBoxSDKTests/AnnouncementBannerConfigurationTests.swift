import XCTest
import SwiftUI
@testable import VoiceBoxSDK

final class AnnouncementBannerConfigurationTests: XCTestCase {

    func testDefaultConfiguration() {
        let config = AnnouncementBannerConfiguration()

        XCTAssertTrue(config.isDismissible)
        XCTAssertNil(config.headerLabel)
        XCTAssertNil(config.titleFont)
        XCTAssertNil(config.titleColor)
        XCTAssertEqual(config.backgroundColor, .white)
    }

    func testCustomConfiguration() {
        let config = AnnouncementBannerConfiguration(
            dismissBehavior: .forever,
            isDismissible: false,
            position: .bottom,
            headerLabel: "News",
            backgroundColor: .blue,
            titleFont: .headline,
            titleColor: .red
        )

        XCTAssertFalse(config.isDismissible)
        XCTAssertEqual(config.headerLabel, "News")
        XCTAssertEqual(config.backgroundColor, .blue)
        XCTAssertEqual(config.titleFont, .headline)
        XCTAssertEqual(config.titleColor, .red)
    }
}
