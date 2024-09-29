import Foundation
@testable import StraussApp

final class MockSearchStraussTracksUseCase: SearchTracksUseCase {

    var result: ([StraussApp.MusicTrack], StraussApp.DomainError?)!

    func callAsFunction() async -> ([StraussApp.MusicTrack], StraussApp.DomainError?) {
        return result
    }

    func reset() {
        result = nil
    }
}
