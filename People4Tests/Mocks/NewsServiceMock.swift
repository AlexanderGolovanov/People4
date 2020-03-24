import Foundation
@testable import People4

class NewsServiceMock: INewsService {
    
    private let parser: RSSParser
    
    init() {
        let url = Bundle(for: type(of: self)).url(forResource: "RSS", withExtension: ".xml")
        guard let dataURL = url, let data = try? Data(contentsOf: dataURL) else {
            fatalError("Couldn't read RSS.xml file")
        }
        parser = RSSParser(data: data, target: .lenta)
    }
    
    func getItems(completionHandler: @escaping (([News]?, ILocalizedError?) -> Void)) {
        parser.parse {  items in
            completionHandler(items.map { News(dto: $0) }, nil)
        }
    }
}
