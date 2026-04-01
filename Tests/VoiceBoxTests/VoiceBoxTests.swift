import XCTest
@testable import VoiceBoxSDK

@MainActor
final class VoiceBoxTests: XCTestCase {

    override func tearDown() {
        // Reset shared instance state
        super.tearDown()
    }

    func testConfigurationSetsApiKey() {
        VoiceBox.configure(apiKey: "test_key_123")

        XCTAssertTrue(VoiceBox.shared.isConfigured)
        XCTAssertEqual(VoiceBox.shared.configuration?.apiKey, "test_key_123")
    }

    func testConfigurationWithClosure() {
        VoiceBox.configure(apiKey: "test_key") { config in
            config.user.email = "test@example.com"
            config.user.payment = .monthly(9.99)
            config.features = .minimal
        }

        XCTAssertEqual(VoiceBox.shared.configuration?.user.email, "test@example.com")
        XCTAssertEqual(VoiceBox.shared.configuration?.features.tabs.roadmap, false)
    }
}
