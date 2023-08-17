import Foundation

protocol SearchStraussTracksUseCase {
    func callAsFunction() async -> ([MusicTrack], DomainError?)
}

struct SearchStraussTracks: SearchStraussTracksUseCase {

    let repository: MusicTrackRepositoryCompatible

    func callAsFunction() async -> ([MusicTrack], DomainError?) {
        await repository.tracks(with: ["richard", "strauss"])
    }
}
