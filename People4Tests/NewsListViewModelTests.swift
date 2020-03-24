import XCTest
@testable import People4

class NewsListViewModelTests: XCTestCase {

    var viewModel: INewsListViewModel!
    
    override func setUp() {
        viewModel = NewsListViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
}
