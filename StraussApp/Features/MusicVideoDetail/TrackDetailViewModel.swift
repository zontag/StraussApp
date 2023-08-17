import Foundation

@MainActor
final class TrackDetailViewModel {

    // MARK: Private properties
    
    private let item: MusicTrack

    // MARK: Public properties

    var trackName: String {
        item.trackName?.capitalized ?? ""
    }

    var image: URL? {
        item.artworkUrl100
    }

    var artistName: String {
        self.item.artistName?.capitalized ?? ""
    }

    var collectionName: String {
        self.item.collectionName?.capitalized ?? ""
    }

    var price: String {
        guard let price = self.item.collectionPrice, let currency = self.item.currency else {
            return ""
        }

        return "\(price) \(currency)"
    }

    var previewURL: URL? {
        self.item.previewUrl
    }

    init(item: MusicTrack) {
        self.item = item
    }
}
