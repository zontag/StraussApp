import Foundation

struct MusicTrack: Hashable {
    
    let artistId: Double?
    let collectionId: Double?
    let trackId: Double?
    let artistName: String?
    let collectionName: String?
    let collectionPrice: Double?
    let trackName: String?
    let currency: String?

    // Thumbnails
    let artworkUrl30: URL?
    let artworkUrl60: URL?
    let artworkUrl100: URL?

    // Preview
    let previewUrl: URL?
}
