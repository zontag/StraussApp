import Foundation
import CoreData

protocol Store {

    func fetchMusicTracks() throws -> [MusicTrackEntity]

    func createMusicTrack(
        artistId: Double,
        collectionId: Double,
        trackId: Double,
        artistName: String?,
        collectionName: String?,
        trackName: String?,
        artistViewUrl: URL?,
        collectionViewUrl: URL?,
        trackViewUrl: URL?,
        previewUrl: URL?,
        artworkUrl30: URL?,
        artworkUrl60: URL?,
        artworkUrl100: URL?,
        collectionPrice: Double,
        trackPrice: Double,
        releaseDate: String?,
        currency: String?)

    func deleteTracks() throws

    func saveContext ()
}

class StraussAppStore: Store {

    // MARK: - Core Data stack
    var persistentContainer: NSPersistentContainer

    init(container: NSPersistentContainer) {
        self.persistentContainer = container
    }

    func fetchMusicTracks() throws -> [MusicTrackEntity] {
        let request = MusicTrackEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "trackName", ascending: true)]
        return try persistentContainer.viewContext.fetch(request)
    }

    func createMusicTrack(
        artistId: Double,
        collectionId: Double,
        trackId: Double,
        artistName: String?,
        collectionName: String?,
        trackName: String?,
        artistViewUrl: URL?,
        collectionViewUrl: URL?,
        trackViewUrl: URL?,
        previewUrl: URL?,
        artworkUrl30: URL?,
        artworkUrl60: URL?,
        artworkUrl100: URL?,
        collectionPrice: Double,
        trackPrice: Double,
        releaseDate: String?,
        currency: String?) {

        guard let entity = NSEntityDescription
            .entity(forEntityName: "MusicTrackEntity",
                    in: persistentContainer.viewContext)
        else { return }

        let object = NSManagedObject(entity: entity,
                                     insertInto: persistentContainer.viewContext)

        object.setValue(artistId, forKeyPath: "artistId")
        object.setValue(collectionId, forKeyPath: "collectionId")
        object.setValue(trackId, forKeyPath: "trackId")
        object.setValue(artistName, forKeyPath: "artistName")
        object.setValue(collectionName, forKeyPath: "collectionName")
        object.setValue(trackName, forKeyPath: "trackName")
        object.setValue(artistViewUrl, forKeyPath: "artistViewUrl")
        object.setValue(collectionViewUrl, forKeyPath: "collectionViewUrl")
        object.setValue(trackViewUrl, forKeyPath: "trackViewUrl")
        object.setValue(previewUrl, forKeyPath: "previewUrl")
        object.setValue(artworkUrl30, forKeyPath: "artworkUrl30")
        object.setValue(artworkUrl60, forKeyPath: "artworkUrl60")
        object.setValue(artworkUrl100, forKeyPath: "artworkUrl100")
        object.setValue(collectionPrice, forKeyPath: "collectionPrice")
        object.setValue(trackPrice, forKeyPath: "trackPrice")
        object.setValue(releaseDate, forKeyPath: "releaseDate")
        object.setValue(currency, forKeyPath: "currency")

    }
    
    func deleteTracks() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "MusicTrackEntity")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try persistentContainer.viewContext.executeAndMergeChanges(using: batchDeleteRequest)
    }

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension NSManagedObjectContext {

    public func executeAndMergeChanges(using batchDeleteRequest: NSBatchDeleteRequest) throws {
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        let result = try execute(batchDeleteRequest) as? NSBatchDeleteResult
        let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] ?? []]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self])
    }
}
