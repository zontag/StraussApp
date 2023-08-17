import XCTest
@testable import StraussApp

final class SearchStraussTracksUseCaseTests: XCTestCase {

    let mockRepo = MockMusicTrackRepository()

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {
        mockRepo.reset()
    }

    func testGetTracksWithSuccess() async throws {

        // Given

        let mockTracks = [
            MusicTrack(artistId: 123,
                       collectionId: 123,
                       trackId: 123,
                       artistName: "value",
                       collectionName: "value",
                       collectionPrice: 10.5,
                       trackName: "value",
                       currency: "value",
                       artworkUrl30: nil,
                       artworkUrl60: nil,
                       artworkUrl100: nil,
                       previewUrl: nil),
            MusicTrack(artistId: 234,
                       collectionId: 234,
                       trackId: 234,
                       artistName: "value",
                       collectionName: "value",
                       collectionPrice: 11.5,
                       trackName: "value",
                       currency: "value",
                       artworkUrl30: nil,
                       artworkUrl60: nil,
                       artworkUrl100: nil,
                       previewUrl: nil)
        ]

        let mockResult: ([MusicTrack], DomainError?) = (mockTracks, nil)

        mockRepo.result = mockResult

        let getTracks = SearchStraussTracks(repository: mockRepo)

        // When
        let (tracks, error) = await getTracks()

        // Then

        XCTAssertTrue(!tracks.isEmpty)
        XCTAssertEqual(tracks.count, 2)
        XCTAssertNil(error)
    }

    func testSearchTracksWithFailure() async throws {

        // Given

        let mockResult: ([MusicTrack], DomainError?) = ([], DomainError.storeFailure)
        mockRepo.result = mockResult

        let searchTracks = SearchStraussTracks(repository: mockRepo)

        // When
        let (tracks, error) = await searchTracks()

        // Then

        XCTAssertTrue(tracks.isEmpty)
        XCTAssertEqual(tracks.count, 0)
        XCTAssertNotNil(error)
        XCTAssertEqual(error, .storeFailure)
    }

}
