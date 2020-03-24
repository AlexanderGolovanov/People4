import Foundation

protocol IRSSParser {
    func parse(completion: (([NewsItemDTO]) -> Void)?)
}

class RSSParser: NSObject, XMLParserDelegate {
    
    // MARK: - Properties
    
    enum ItemKey: String {
        case title = "title"
        case description = "description"
        case link = "link"
        case date = "pubDate"
        case image = "enclosure"
        case category = "category"
        case unknown
    }
    
    private let xmlParser: XMLParser
    private let target: ApiTarget
    private var items: [NewsItemDTO] = []
    private var elements: [ItemKey: String] = [:]
    private var currentItemKey: ItemKey?
    private var isInsideNode = false
    private var nodeName = "item"
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        return formatter
    }()
    
    public var completion: (([NewsItemDTO]) -> Void)?
    
    // MARK: - Lifecycle
    
    init(data: Data, target: ApiTarget) {
        self.xmlParser = XMLParser(data: data)
        self.target = target
    }
    
    func parse(completion: (([NewsItemDTO]) -> Void)?) {
        self.completion = completion
        xmlParser.delegate = self
        xmlParser.parse()
    }
    
    // MARK: - XMLParserDelegate
    
    func parserDidStartDocument(_ parser: XMLParser) {
        items = []
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == nodeName {
            isInsideNode = true
            return
        }
        if let elementItem = ItemKey(rawValue: elementName), isInsideNode {
            switch elementItem {
            case .image:
                if let url = attributeDict["url"] {
                    elements.updateValue(url, forKey: .image)
                }
            default:
                currentItemKey = elementItem
            }
        } else {
            currentItemKey = .unknown
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentItemKey = nil
        guard isInsideNode, elementName == nodeName else { return }
        guard let item = getNewsItem(from: elements) else { return }
        items.append(item)
        elements = [:]
        isInsideNode = false
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard let item = currentItemKey, item != .unknown, isInsideNode else { return }
        let value = (elements[item] ?? "") + string
        elements.updateValue(value, forKey: item)
    }
    
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        guard isInsideNode else { return }
        let text = String(data: CDATABlock, encoding: .utf8)
        elements.updateValue(text ?? "", forKey: .description)
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        completion?(items)
    }
    
    // MARK: - Private
    
    private func getNewsItem(from nodes: [ItemKey: String]) -> NewsItemDTO? {
        guard
            let title = nodes[.title],
            let linkStr = nodes[.link],
            let url = URL(string: linkStr),
            let dateStr = nodes[.date],
            let date = dateFormatter.date(from: dateStr)
        else { return nil }
        let imageStr = nodes[.image]
        let imageURL = imageStr == nil ? nil : URL(string: imageStr!)
        return NewsItemDTO(title: title, link: url, imageURL: imageURL, category: nodes[.category], date: date, description: (nodes[.description] ?? ""), source: target)
    }
}
