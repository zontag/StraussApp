import Foundation

protocol MusicTrackRepositoryCompatible {
    func tracks(with terms: [String]) async -> ([MusicTrack], DomainError?)
}

final class MusicTrackRepository<Remote: API, Storage: Store>: MusicTrackRepositoryCompatible, Loging {

    private let api: Remote
    private let storage: Storage

    init(api: Remote, storage: Storage) {
        self.api = api
        self.storage = storage
    }

    /// Fetches tracks and returns the existing stored content.
    /// The return will include an error if something wrong happens during the API request or database update.
    /// - Returns: Returns tracks in the domain format and an error if something wrong happens while fetching or persisting data
    func tracks(with terms: [String]) async -> ([MusicTrack], DomainError?) {

        var resultResponse: [ResultResponse] = []
        var fetchError: DomainError?

        // Fetching data asynchronous
        do {
            let searchResponse = try await self.api.search(terms: terms, entity: .musicTrack)
            resultResponse = searchResponse.results ?? []
        } catch {
            log(error)
            // Mapping the error for future propagation
            fetchError = DomainError.remoteFailure
        }

        // As long as we have good results from API,
        // delete all existing data and recreate it with the new one
        if !resultResponse.isEmpty && fetchError == nil {
            do {
                try storage.deleteTracks()
                for result in resultResponse {
                    storage.createMusicTrack(
                        artistId: result.artistId ?? 0,
                        collectionId: result.collectionId ?? 0,
                        trackId: result.trackId ?? 0,
                        artistName: result.artistName,
                        collectionName: result.collectionName,
                        trackName: result.trackName,
                        artistViewUrl: result.artistViewUrl,
                        collectionViewUrl: result.collectionViewUrl,
                        trackViewUrl: result.trackViewUrl,
                        previewUrl: result.previewUrl,
                        artworkUrl30: result.artworkUrl30,
                        artworkUrl60: result.artworkUrl60,
                        artworkUrl100: result.artworkUrl100,
                        collectionPrice: result.collectionPrice ?? -1,
                        trackPrice: result.trackPrice ?? -1,
                        releaseDate: result.releaseDate,
                        currency: result.currency)
                }

                storage.saveContext()
            } catch {
                log(error)
                // Mapping the error for future propagation
                fetchError = DomainError.storeFailure
            }
        }

        // Fetch existing (probably updated) data and return the result.
        do {
            let storedMusicVideos = try storage.fetchMusicTracks()
            let domainMusicVideos = storedMusicVideos.map { $0.toDomain }
            return (domainMusicVideos, fetchError)
        } catch {
            log(error)
            return ([], DomainError.storeFailure)
        }
    }
}
