import Foundation

protocol ILocalizedError: Error {
    var localizedMessage: String { get }
}

enum ApiError {
    case mappingFailed
    case missingData
    case networkError(message: String)
}

extension ApiError: ILocalizedError {
    var localizedMessage: String {
        switch self {
        case .mappingFailed:
            return "mappingFailed"
        case .missingData:
            return "missingData"
        case .networkError(let message):
            return message
        }
    }
}
