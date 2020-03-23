import Foundation

enum ApiResponse<T> {
    case onSuccess(items: [T])
    case onError(error: ILocalizedError)
}
