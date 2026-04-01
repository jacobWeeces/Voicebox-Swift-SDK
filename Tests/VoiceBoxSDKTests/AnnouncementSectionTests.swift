import XCTest
@testable import VoiceBoxSDK

final class AnnouncementSectionTests: XCTestCase {

    func testDecodesFromJSON() throws {
        let json = """
        [
            {"title": "Bug Fixes", "items": ["Fixed crash", "Login timeout resolved"]},
            {"title": "New Features", "items": ["Dark mode"]}
        ]
        """.data(using: .utf8)!

        let sections = try JSONDecoder().decode([AnnouncementSection].self, from: json)

        XCTAssertEqual(sections.count, 2)
        XCTAssertEqual(sections[0].title, "Bug Fixes")
        XCTAssertEqual(sections[0].items, ["Fixed crash", "Login timeout resolved"])
        XCTAssertEqual(sections[1].title, "New Features")
        XCTAssertEqual(sections[1].items, ["Dark mode"])
    }

    func testEncodesToJSON() throws {
        let sections = [
            AnnouncementSection(title: "Updates", items: ["Item one", "Item two"])
        ]

        let data = try JSONEncoder().encode(sections)
        let decoded = try JSONDecoder().decode([AnnouncementSection].self, from: data)

        XCTAssertEqual(decoded.count, 1)
        XCTAssertEqual(decoded[0].title, "Updates")
        XCTAssertEqual(decoded[0].items, ["Item one", "Item two"])
    }

    func testParsesFromAnnouncementBody() throws {
        let bodyJSON = """
        [{"title":"What's New","items":["Feature A","Feature B"]}]
        """

        guard let data = bodyJSON.data(using: .utf8) else {
            XCTFail("Could not encode string")
            return
        }

        let sections = try JSONDecoder().decode([AnnouncementSection].self, from: data)
        XCTAssertEqual(sections.count, 1)
        XCTAssertEqual(sections[0].title, "What's New")
        XCTAssertEqual(sections[0].items.count, 2)
    }
}
