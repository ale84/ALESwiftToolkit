//
//  Created by Alessio on 23/01/26
//  Copyright © 2026 Alessio Orlando. All rights reserved.
//




import Testing
@preconcurrency import CoreData
@testable import ALESwiftToolkit

@Suite
struct EntityMonitorSwiftTestingTests {

    // MARK: - Programmatic Core Data stack (in-memory)

    func makeInMemoryContainer() async -> NSPersistentContainer {
        let model = NSManagedObjectModel()

        let entity = NSEntityDescription()
        entity.name = "MyEntity"
        entity.managedObjectClassName = NSStringFromClass(MyEntity.self)

        let nameAttr = NSAttributeDescription()
        nameAttr.name = "name"
        nameAttr.attributeType = .stringAttributeType
        nameAttr.isOptional = true

        entity.properties = [nameAttr]
        model.entities = [entity]

        let container = NSPersistentContainer(name: "Model", managedObjectModel: model)
        let desc = NSPersistentStoreDescription()
        desc.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [desc]

        // Load synchronously with a continuation
        await withCheckedContinuation { cont in
            container.loadPersistentStores { _, error in
                #expect(error == nil)
                cont.resume()
            }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }

    // MARK: - Test entity

    final class MyEntity: NSManagedObject {
        @NSManaged var name: String?
    }

    @Test
    func changesStreamEmitsInsertUpdateDeleteIDs() async throws {
        let container = await makeInMemoryContainer()
        let context = container.viewContext

        let monitor = EntityMonitor<MyEntity>(context: context, observingOption: .objectChanges)

        // Flags updated by the consumer task
        final class Flags {
            var sawInsert = false
            var sawUpdate = false
            var sawDelete = false
        }
        let flags = Flags()

        // Consumer
        let consumer = Task {
            for await changes in monitor.changesStream() {
                if !changes.inserts.isEmpty { flags.sawInsert = true }
                if !changes.updates.isEmpty { flags.sawUpdate = true }
                if !changes.deletes.isEmpty { flags.sawDelete = true }
                if flags.sawInsert && flags.sawUpdate && flags.sawDelete { break }
            }
        }
        defer { consumer.cancel() }

        // Producer: insert/update/delete on the context queue
        let objectID = try await context.perform {
            let obj = MyEntity(context: context)
            obj.name = "Alpha"
            try context.save()
            return obj.objectID
        }

        try await context.perform {
            let obj = try context.existingObject(with: objectID) as! MyEntity
            obj.name = "Alpha (updated)"
            try context.save()
        }

        try await context.perform {
            let obj = try context.existingObject(with: objectID)
            context.delete(obj)
            try context.save()
        }

        // Give the notification stream a moment (Core Data is fast, but async delivery isn't guaranteed immediate)
        try await Task.sleep(nanoseconds: 300_000_000)

        #expect(flags.sawInsert)
        #expect(flags.sawUpdate)
        #expect(flags.sawDelete)
    }
}
