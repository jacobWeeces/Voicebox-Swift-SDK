import XCTest
@testable import VoiceBoxSDK

final class ConfigurationTests: XCTestCase {

    func testDefaultConfiguration() {
        let config = Configuration(apiKey: "test")

        XCTAssertEqual(config.apiKey, "test")
        XCTAssertNil(config.user.email)
        XCTAssertTrue(config.features.voting.enabled)
    }

    func testPaymentTypes() {
        XCTAssertEqual(Payment.none.interval, "none")
        XCTAssertEqual(Payment.monthly(9.99).interval, "monthly")
        XCTAssertEqual(Payment.monthly(9.99).amount, 9.99)
        XCTAssertEqual(Payment.yearly(99.99).interval, "yearly")
        XCTAssertEqual(Payment.lifetime(199.99).interval, "lifetime")
    }
}
