import XCTest
@testable import StraussApp

final class StorageTests: XCTestCase {

    var store: StraussAppStore!

    override func setUpWithError() throws {
        let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        store = StraussAppStore(container: container!)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStorageCreateAndLoadTrack() throws {

        // Given
        let id = 1234.0
        let someDouble = 10.5
        let url = URL(string: "https://google.com")!
        let someString = "value"

        // When
        store.createMusicTrack(
            artistId: id,
            collectionId: id,
            trackId: id,
            artistName: someString,
            collectionName: someString,
            trackName: someString,
            artistViewUrl: url,
            collectionViewUrl: url,
            trackViewUrl: url,
            previewUrl: url,
            artworkUrl30: url,
            artworkUrl60: url,
            artworkUrl100: url,
            collectionPrice: someDouble,
            trackPrice: someDouble,
            releaseDate: someString,
            currency: someString)

        store.saveContext()

        // Then
        let result = try store.fetchMusicTracks()
        XCTAssertTrue(!result.isEmpty)
        XCTAssertEqual(result.first!.artistId, id)
        XCTAssertEqual(result.first!.collectionId, id)
        XCTAssertEqual(result.first!.trackId, id)
        XCTAssertEqual(result.first!.artistName, someString)
        XCTAssertEqual(result.first!.collectionName, someString)
        XCTAssertEqual(result.first!.trackName, someString)
        XCTAssertEqual(result.first!.artistViewUrl, url)
        XCTAssertEqual(result.first!.collectionViewUrl, url)
        XCTAssertEqual(result.first!.trackViewUrl, url)
        XCTAssertEqual(result.first!.previewUrl, url)
        XCTAssertEqual(result.first!.artworkUrl30, url)
        XCTAssertEqual(result.first!.artworkUrl60, url)
        XCTAssertEqual(result.first!.artworkUrl100, url)
        XCTAssertEqual(result.first!.collectionPrice, someDouble)
        XCTAssertEqual(result.first!.trackPrice, someDouble)
        XCTAssertEqual(result.first!.releaseDate, someString)
        XCTAssertEqual(result.first!.currency, someString)
    }

    func testStorageCreateAndDeleteTrack() throws {

        // Given
        let id = 1234.0
        let someDouble = 10.5
        let url = URL(string: "https://google.com")!
        let someString = "value"

        // When
        store.createMusicTrack(
            artistId: id,
            collectionId: id,
            trackId: id,
            artistName: someString,
            collectionName: someString,
            trackName: someString,
            artistViewUrl: url,
            collectionViewUrl: url,
            trackViewUrl: url,
            previewUrl: url,
            artworkUrl30: url,
            artworkUrl60: url,
            artworkUrl100: url,
            collectionPrice: someDouble,
            trackPrice: someDouble,
            releaseDate: someString,
            currency: someString)

        store.saveContext()

        // Then
        let tracks = try store.fetchMusicTracks()
        XCTAssertTrue(!tracks.isEmpty)

        try store.deleteTracks()
        
        let result = try store.fetchMusicTracks()
        XCTAssertTrue(result.isEmpty)
    }
}
