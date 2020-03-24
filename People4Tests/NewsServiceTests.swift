import XCTest
@testable import People4

class NewsServiceTests: XCTestCase {

    var lentaNewsService: INewsService!
    var gazetaNewsService: INewsService!
    var customNewsService: INewsService!
    
    override func setUp() {
        lentaNewsService = NewsService(provider: ApiProvider(target: .lenta))
        gazetaNewsService = NewsService(provider: ApiProvider(target: .gazeta))
        customNewsService = NewsService(provider: ApiProvider(target: .none))
    }

    override func tearDown() {
        lentaNewsService = nil
        gazetaNewsService = nil
        customNewsService = nil
        super.tearDown()
    }

    func testLentaNewsService() {
        testGettingItems(from: lentaNewsService) { (items, error) in
            XCTAssert(error == nil, error!.localizedMessage)
            if let items = items {
                XCTAssert(!items.isEmpty, "Collection is empty")
            }
        }
    }
    
    func testGazetaNewsService() {
        testGettingItems(from: gazetaNewsService) { (items, error) in
            XCTAssert(error == nil, error!.localizedMessage)
            if let items = items {
                XCTAssert(!items.isEmpty, "Collection is empty")
            }
        }
    }
    
    func testCustomNewsService() {
        testGettingItems(from: customNewsService) { (items, error) in
            XCTAssert(error != nil, "Must be error there")
        }
    }
    
    func testGettingItems(from newsService: INewsService, completionHandler: @escaping (([News]?, ILocalizedError?) -> Void)) {
        let expectation = XCTestExpectation(description: "Loading news")
        newsService.getItems { (items, error) in
            completionHandler(items, error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

}
