import XCTest
@testable import People4

class NewsAggregatorServiceTests: XCTestCase {

    var newsAggregator: INewsAggregatorService!
    
    override func setUp() {
        newsAggregator = NewsAggregatorService(sources: NewsService(provider: ApiProviderMock()))
    }

    override func tearDown() {
        newsAggregator = nil
        super.tearDown()
    }

    func testGettingItems() {
        newsAggregator.getItems { (items, error) in
            if let _ = error {
                XCTFail("getting items error")
                return
            }
            guard let items = items else {
                XCTFail("Items is nil")
                return
            }
            XCTAssertTrue(!items.isEmpty, "Items is empty")
        }
    }

}
