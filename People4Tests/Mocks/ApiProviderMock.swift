import Foundation
@testable import People4

class ApiProviderMock: IApiProvider {
    
    private let parser: RSSParser
    
    init() {
        let url = Bundle(for: type(of: self)).url(forResource: "RSS", withExtension: ".xml")
        guard let dataURL = url, let data = try? Data(contentsOf: dataURL) else {
            fatalError("Couldn't read RSS.xml file")
        }
        parser = RSSParser(data: data, target: .lenta)
    }
    
    func getItems<T: Codable>(completionHandler: @escaping ((ApiResponse<T>) -> Void)) {
        parser.parse { items in
            if items.isEmpty {
                completionHandler(ApiResponse.onError(error: ApiError.missingData))
            } else {
                completionHandler(.onSuccess(items: items as! [T]))
            }
        }
    }
}
