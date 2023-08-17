import XCTest
import CoreData
@testable import StraussApp

final class TracksRepositoryTests: XCTestCase {

    private var repository: MusicTrackRepositoryCompatible!
    private let mockAPI = MockAPI()
    private var mockStore: MockStore!

    override func setUpWithError() throws {
        mockStore = MockStore()
        repository = MusicTrackRepository(api: mockAPI, storage: mockStore)
    }

    override func tearDownWithError() throws {
        mockAPI.reset()
        mockStore = nil
    }

    func testTracksRepositoryFetchWithSuccess() async throws {

        // Given
        mockAPI.tracksJsonFileName = "Tracks"

        mockStore.createMusicTrack(
            artistId: 0,
            collectionId: 0,
            trackId: 0,
            artistName: "To be Deleted",
            collectionName: "To be Deleted",
            trackName: "To be Deleted",
            artistViewUrl: nil,
            collectionViewUrl: nil,
            trackViewUrl: nil,
            previewUrl: nil,
            artworkUrl30: nil,
            artworkUrl60: nil,
            artworkUrl100: nil,
            collectionPrice: 0,
            trackPrice: 10,
            releaseDate: "",
            currency: "USD")


        mockStore.saveContext()

        // When
        let (tracks, error) = await repository.tracks(with: ["richard", "strauss"])

        // Then
        XCTAssertNil(error)
        XCTAssertEqual(tracks.count, 50)
        XCTAssertEqual(tracks.first!.artistId, 94595695.0)
    }

    func testTracksRepositoryFetchWithAPIError() async throws {

        // Given
        mockAPI.tracksFailure = APIFailure.invalidResponse

        mockStore.createMusicTrack(
            artistId: 12345,
            collectionId: 0,
            trackId: 0,
            artistName: "Old",
            collectionName: "Old",
            trackName: "Old",
            artistViewUrl: nil,
            collectionViewUrl: nil,
            trackViewUrl: nil,
            previewUrl: nil,
            artworkUrl30: nil,
            artworkUrl60: nil,
            artworkUrl100: nil,
            collectionPrice: 0,
            trackPrice: 10,
            releaseDate: "",
            currency: "USD")

        mockStore.saveContext()

        // When
        let (tracks, error) = await repository.tracks(with: ["richard", "strauss"])

        // Then
        XCTAssertNotNil(error)
        XCTAssertEqual(error!, DomainError.remoteFailure)
        XCTAssertEqual(tracks.count, 1)
        XCTAssertEqual(tracks.first!.artistId, 12345)
    }

    func testTracksRepositoryFetchWithStoreDeleteActionError() async throws {

        // Given
        mockStore.deleteTracksFailure = CocoaError(CocoaError.coreData)

        mockStore.createMusicTrack(
            artistId: 12345,
            collectionId: 0,
            trackId: 0,
            artistName: "Old",
            collectionName: "Old",
            trackName: "Old",
            artistViewUrl: nil,
            collectionViewUrl: nil,
            trackViewUrl: nil,
            previewUrl: nil,
            artworkUrl30: nil,
            artworkUrl60: nil,
            artworkUrl100: nil,
            collectionPrice: 0,
            trackPrice: 10,
            releaseDate: "",
            currency: "USD")

        mockStore.saveContext()

        // When
        let (tracks, error) = await repository.tracks(with: ["richard", "strauss"])

        // Then
        XCTAssertNotNil(error)
        XCTAssertEqual(error!, DomainError.storeFailure)
        XCTAssertEqual(tracks.count, 1)
        XCTAssertEqual(tracks.first!.artistId, 12345)
    }

    func testTracksRepositoryFetchWithStoreFetchActionError() async throws {

        // Given
        mockStore.fetchTracksFailure = CocoaError(CocoaError.coreData)

        mockStore.createMusicTrack(
            artistId: 12345,
            collectionId: 0,
            trackId: 0,
            artistName: "Old",
            collectionName: "Old",
            trackName: "Old",
            artistViewUrl: nil,
            collectionViewUrl: nil,
            trackViewUrl: nil,
            previewUrl: nil,
            artworkUrl30: nil,
            artworkUrl60: nil,
            artworkUrl100: nil,
            collectionPrice: 0,
            trackPrice: 10,
            releaseDate: "",
            currency: "USD")

        mockStore.saveContext()

        // When
        let (tracks, error) = await repository.tracks(with: ["richard", "strauss"])

        // Then
        XCTAssertNotNil(error)
        XCTAssertEqual(error!, DomainError.storeFailure)
        XCTAssertEqual(tracks.count, 0)
    }
}
