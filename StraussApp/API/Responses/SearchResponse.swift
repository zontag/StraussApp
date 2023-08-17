import Foundation

// MARK: - SearchResult
struct SearchResponse: Codable {
    let resultCount: Int?
    let results: [ResultResponse]?
}
