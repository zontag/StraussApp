import Foundation

protocol SearchTracksUseCase {
    func callAsFunction() async -> ([MusicTrack], DomainError?)
}

struct SearchStraussTracks: SearchTracksUseCase {

    let repository: MusicTrackRepositoryCompatible

    func callAsFunction() async -> ([MusicTrack], DomainError?) {
        await repository.tracks(with: ["richard", "strauss"])
    }
}
