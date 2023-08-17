import Foundation
import CoreData

extension MusicTrackEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MusicTrackEntity> {
        return NSFetchRequest<MusicTrackEntity>(entityName: "MusicTrackEntity")
    }

    @NSManaged public var artistId: Double
    @NSManaged public var collectionId: Double
    @NSManaged public var trackId: Double
    @NSManaged public var artistName: String?
    @NSManaged public var collectionName: String?
    @NSManaged public var trackName: String?
    @NSManaged public var artistViewUrl: URL?
    @NSManaged public var collectionViewUrl: URL?
    @NSManaged public var trackViewUrl: URL?
    @NSManaged public var previewUrl: URL?
    @NSManaged public var artworkUrl30: URL?
    @NSManaged public var artworkUrl60: URL?
    @NSManaged public var artworkUrl100: URL?
    @NSManaged public var collectionPrice: Double
    @NSManaged public var trackPrice: Double
    @NSManaged public var releaseDate: String?
    @NSManaged public var currency: String?

}

extension MusicTrackEntity: Identifiable { }

extension MusicTrackEntity {

    var toDomain: MusicTrack {
        .init(artistId: artistId,
              collectionId: collectionId,
              trackId: trackId,
              artistName: artistName,
              collectionName: collectionName,
              collectionPrice: collectionPrice,
              trackName: trackName,
              currency: currency,
              artworkUrl30: artworkUrl30,
              artworkUrl60: artworkUrl60,
              artworkUrl100: artworkUrl100,
              previewUrl: previewUrl)
    }
}
