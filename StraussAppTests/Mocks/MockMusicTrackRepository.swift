import Foundation
@testable import StraussApp

final class MockMusicTrackRepository: MusicTrackRepositoryCompatible {

    var result: ([StraussApp.MusicTrack], StraussApp.DomainError?)!

    func tracks(with terms: [String]) async -> ([StraussApp.MusicTrack], StraussApp.DomainError?) {
        return result
    }

    func reset() {
        result = nil
    }
}
