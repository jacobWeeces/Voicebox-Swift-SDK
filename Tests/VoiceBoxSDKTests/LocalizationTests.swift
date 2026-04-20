import XCTest
@testable import VoiceBoxSDK

final class LocalizationTests: XCTestCase {

    func testTimeAgoSingularMinute() {
        let l10n = Localization()
        let date = Date().addingTimeInterval(-60)
        XCTAssertEqual(l10n.timeAgo(date), "1 minute ago")
    }

    func testTimeAgoPluralMinutes() {
        let l10n = Localization()
        let date = Date().addingTimeInterval(-180)
        XCTAssertEqual(l10n.timeAgo(date), "3 minutes ago")
    }

    func testTimeAgoSingularHour() {
        let l10n = Localization()
        let date = Date().addingTimeInterval(-3600)
        XCTAssertEqual(l10n.timeAgo(date), "1 hour ago")
    }

    func testTimeAgoPluralHours() {
        let l10n = Localization()
        let date = Date().addingTimeInterval(-7200)
        XCTAssertEqual(l10n.timeAgo(date), "2 hours ago")
    }

    func testTimeAgoSingularDay() {
        let l10n = Localization()
        let date = Date().addingTimeInterval(-86400)
        XCTAssertEqual(l10n.timeAgo(date), "1 day ago")
    }

    func testTimeAgoPluralDays() {
        let l10n = Localization()
        let date = Date().addingTimeInterval(-86400 * 3)
        XCTAssertEqual(l10n.timeAgo(date), "3 days ago")
    }

    func testTimeAgoSingularWeek() {
        let l10n = Localization()
        let date = Date().addingTimeInterval(-604800)
        XCTAssertEqual(l10n.timeAgo(date), "1 week ago")
    }

    func testTimeAgoPluralWeeks() {
        let l10n = Localization()
        let date = Date().addingTimeInterval(-604800 * 2)
        XCTAssertEqual(l10n.timeAgo(date), "2 weeks ago")
    }

    func testTimeAgoSingularMonth() {
        let l10n = Localization()
        let date = Date().addingTimeInterval(-2592000)
        XCTAssertEqual(l10n.timeAgo(date), "1 month ago")
    }

    func testTimeAgoPluralMonths() {
        let l10n = Localization()
        let date = Date().addingTimeInterval(-2592000 * 3)
        XCTAssertEqual(l10n.timeAgo(date), "3 months ago")
    }

    func testTimeAgoJustNow() {
        let l10n = Localization()
        let date = Date().addingTimeInterval(-10)
        XCTAssertEqual(l10n.timeAgo(date), "Just now")
    }

    func testCustomSingularOverrideRespected() {
        var l10n = Localization()
        l10n.dayAgo = "%d día atrás"
        l10n.daysAgo = "%d días atrás"
        let singular = Date().addingTimeInterval(-86400)
        let plural = Date().addingTimeInterval(-86400 * 4)
        XCTAssertEqual(l10n.timeAgo(singular), "1 día atrás")
        XCTAssertEqual(l10n.timeAgo(plural), "4 días atrás")
    }
}
