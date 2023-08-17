import Foundation
@testable import StraussApp
import UIKit
import CoreData

final class MockStore: StraussAppStore {

    var fetchTracksFailure: Error?
    var deleteTracksFailure: Error?

    init() {

        let modelName = "StraussAppStore"

        let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
        let model: NSManagedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!

        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSSQLiteStoreType

        let container = NSPersistentContainer(name: modelName, managedObjectModel: model)

        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        super.init(container: container)
    }

    override func fetchMusicTracks() throws -> [StraussApp.MusicTrackEntity] {
        if let fetchTracksFailure { throw fetchTracksFailure }
        return try super.fetchMusicTracks()
    }

    override func deleteTracks() throws {
        if let deleteTracksFailure { throw deleteTracksFailure }
        try super.deleteTracks()
    }

    func reset() {
        fetchTracksFailure = nil
        deleteTracksFailure = nil
    }
}
