import Foundation

@MainActor
final class SearchResultViewModel<SomeSearchStraussTracks: SearchTracksUseCase> {

    // MARK: Private properties
    private let searchTracks: SomeSearchStraussTracks

    // MARK: Public properties
    var items: [MusicTrack] = []
        { didSet { onItemsChanged?() } }

    var onItemsChanged: (() -> Void)?

    var onError: (() -> Void)?

    let title: String = "Richard Strauss".uppercased()

    // MARK: Init
    init(searchTracks: SomeSearchStraussTracks) {
        self.searchTracks = searchTracks
    }

    // MARK: Public functions
    func search() {
        Task(priority: .userInitiated) {
            let (items, error) = await searchTracks()
            self.items = items
            if error != nil { onError?() }
        }
    }

    func track(for index: Int) -> MusicTrack? {
        if index >= items.count { return nil }
        return items[index]
    }

    func trackName(for index: Int) -> String {
        if index >= items.count { return "" }
        return items[index].trackName?.capitalized ?? ""
    }

    func artistName(for index: Int) -> String {
        if index >= items.count { return "" }
        return items[index].artistName?.capitalized ?? ""
    }
}
