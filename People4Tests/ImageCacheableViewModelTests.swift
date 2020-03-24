import XCTest
@testable import People4

class ImageCacheableViewModel: IImageCacheableViewModel {}

class ImageCacheableViewModelTests: XCTestCase {

    var viewModel: IImageCacheableViewModel!
    var fakeNews: News!
    var normalNews: News!
    
    override func setUp() {
        fakeNews = News(title: "Test News", link: URL(string: "http://google.com")!, imageURL: URL(string: "http://google.com")!, date: Date(), category: "Sample category", description: "Sample description", source: .lenta)
        normalNews = News(title: "Test News", link: URL(string: "http://google.com")!, imageURL: URL(string: "https://habrastorage.org/webt/3d/xw/t5/3dxwt5scumx16ymje6dqhbn0utk.png")!, date: Date(), category: "Sample category", description: "Sample description", source: .lenta)
        viewModel = ImageCacheableViewModel()
    }

    override func tearDown() {
        viewModel = nil
        fakeNews = nil
        normalNews = nil
        super.tearDown()
    }
    
    func testLoadImageByFakeURL() {
        let expectation = XCTestExpectation(description: "Loading image")
        guard let url = fakeNews.imageURL else {
            XCTFail("Image is nill")
            return
        }
        viewModel.loadImage(url: url) { result in
            switch result {
            case .failure: break
            case .success:
                XCTFail("12")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testLoadNormalImage() {
        let expectation = XCTestExpectation(description: "Loading image")
        guard let url = normalNews.imageURL else {
            XCTFail("Image is nill")
            return
        }
        viewModel.loadImage(url: url) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
