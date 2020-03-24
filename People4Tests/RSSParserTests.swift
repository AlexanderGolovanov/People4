import XCTest
@testable import People4

class RSSParserTests: XCTestCase {

    var parser: RSSParser!
    
    override func setUp() {
        let url = Bundle(for: type(of: self)).url(forResource: "RSS", withExtension: ".xml")
        guard let dataURL = url, let data = try? Data(contentsOf: dataURL) else {
            fatalError("Couldn't read RSS.xml file")
        }
        parser = RSSParser(data: data, target: .lenta)
    }

    override func tearDown() {
        parser = nil
        super.tearDown()
    }

    func testXMLParsing() {
        let expectation = XCTestExpectation(description: "Loading image")
        parser.parse { items in
            XCTAssertTrue(!items.isEmpty, "Items must be non empty")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
