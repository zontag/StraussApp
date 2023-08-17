import Foundation

// MARK: - Result
struct ResultResponse: Codable {
    let wrapperType: String?
    let kind: String?
    let artistId: Double?
    let collectionId: Double?
    let trackId: Double?
    let artistName: String?
    let collectionName: String?
    let trackName: String?
    let collectionCensoredName: String?
    let trackCensoredName: String?
    let artistViewUrl: URL?
    let collectionViewUrl: URL?
    let trackViewUrl: URL?
    let previewUrl: URL?
    let artworkUrl30: URL?
    let artworkUrl60: URL?
    let artworkUrl100: URL?
    let collectionPrice: Double?
    let trackPrice: Double?
    let releaseDate: String?
    let collectionExplicitness: String?
    let trackExplicitness: String?
    let discCount: Double?
    let discNumber: Double?
    let trackCount: Double?
    let trackNumber: Double?
    let trackTimeMillis: Double?
    let country: String?
    let currency: String?
    let primaryGenreName: String?
}
