import XCTest
@testable import StraussApp

@MainActor
final class SearchResultViewModelTests: XCTestCase {

    let searchTracksMock = MockSearchStraussTracksUseCase()
    var viewModel: SearchResultViewModel<MockSearchStraussTracksUseCase>!

    override func setUpWithError() throws {
        viewModel = SearchResultViewModel(searchTracks: searchTracksMock)
    }

    override func tearDownWithError() throws {
        searchTracksMock.reset()
    }

    func testTracksViewModel() async throws {

        // Given
        let expectation1 = XCTestExpectation(description: "On Tracks Changed")
        let expectation2 = XCTestExpectation(description: "On Error")

        let tracksMock = [
            MusicTrack(artistId: 123,
                       collectionId: 123,
                       trackId: 123,
                       artistName: "value1",
                       collectionName: "value1",
                       collectionPrice: 10.5,
                       trackName: "value1",
                       currency: "value1",
                       artworkUrl30: nil,
                       artworkUrl60: nil,
                       artworkUrl100: nil,
                       previewUrl: nil),
            MusicTrack(artistId: 234,
                       collectionId: 234,
                       trackId: 234,
                       artistName: "value2",
                       collectionName: "value2",
                       collectionPrice: 11.5,
                       trackName: "value2",
                       currency: "value2",
                       artworkUrl30: nil,
                       artworkUrl60: nil,
                       artworkUrl100: nil,
                       previewUrl: nil)
        ]

        searchTracksMock.result = (tracksMock, DomainError.storeFailure)

        viewModel.onItemsChanged = {

            // Then
            XCTAssertEqual(self.viewModel.trackName(for: 0), "Value1")
            XCTAssertEqual(self.viewModel.artistName(for: 0), "Value1")

            XCTAssertEqual(self.viewModel.trackName(for: 1), "Value2")
            XCTAssertEqual(self.viewModel.artistName(for: 1), "Value2")

            expectation1.fulfill()
        }

        viewModel.onError = {

            // Then
            expectation2.fulfill()
        }

        // When
        viewModel.search()

        await fulfillment(of: [expectation1, expectation2], timeout: 2)
    }
}
