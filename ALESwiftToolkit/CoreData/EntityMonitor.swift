//
//  Created by Alessio on 04/08/2020
//  Copyright © 2025 Alessio Orlando. All rights reserved.
//


import Foundation
import CoreData

public final class EntityMonitor<T: NSManagedObject> {

    public typealias EntityChangeIDs = (
        inserts: Set<NSManagedObjectID>,
        updates: Set<NSManagedObjectID>,
        deletes: Set<NSManagedObjectID>
    )

    public typealias ChangesHandler = @Sendable (EntityChangeIDs) -> Void

    public enum ObservingOption {
        case contextDidSave
        case objectChanges

        var notificationName: Notification.Name {
            switch self {
            case .contextDidSave:
                return .NSManagedObjectContextDidSave
            case .objectChanges:
                return .NSManagedObjectContextObjectsDidChange
            }
        }
    }

    private let managedObjectContext: NSManagedObjectContext
    private let notificationCenter: NotificationCenter
    private let observingOption: ObservingOption

    private var observer: NSObjectProtocol?
    private var changesHandler: ChangesHandler?

    public init(
        context: NSManagedObjectContext,
        observingOption: ObservingOption,
        notificationCenter: NotificationCenter = .default
    ) {
        self.managedObjectContext = context
        self.observingOption = observingOption
        self.notificationCenter = notificationCenter
    }

    deinit {
        stopMonitoring()
    }

    // MARK: - Closure API

    public func startMonitoring(handler: @escaping ChangesHandler) {
        // Avoid double registration.
        stopMonitoring()

        self.changesHandler = handler

        // Capture only what we need (no self) to avoid Sendable warnings.
        let name = observingOption.notificationName
        let context = managedObjectContext
        let center = notificationCenter
        let handlerCopy = handler

        observer = center.addObserver(forName: name, object: context, queue: nil) { notification in
            guard let userInfo = notification.userInfo else { return }

            let inserts = Self.extractIDs(userInfo[NSInsertedObjectsKey], filtering: T.self)
            let updates = Self.extractIDs(userInfo[NSUpdatedObjectsKey], filtering: T.self)
            let deletes = Self.extractIDs(userInfo[NSDeletedObjectsKey], filtering: T.self)

            guard !(inserts.isEmpty && updates.isEmpty && deletes.isEmpty) else { return }
            handlerCopy((inserts: inserts, updates: updates, deletes: deletes))
        }
    }

    public func stopMonitoring() {
        if let observer {
            notificationCenter.removeObserver(observer)
            self.observer = nil
        }
        self.changesHandler = nil
    }

    // MARK: - AsyncStream API

    /// Stream of changes as `NSManagedObjectID`.
    /// When the consumer stops iterating, the observer is removed.
    public func changesStream() -> AsyncStream<EntityChangeIDs> {
        let name = observingOption.notificationName
        let context = managedObjectContext
        let center = notificationCenter

        return AsyncStream { continuation in
            let task = Task {
                for await notification in center.notifications(named: name, object: context) {
                    guard let userInfo = notification.userInfo else { continue }

                    let inserts = Self.extractIDs(userInfo[NSInsertedObjectsKey], filtering: T.self)
                    let updates = Self.extractIDs(userInfo[NSUpdatedObjectsKey], filtering: T.self)
                    let deletes = Self.extractIDs(userInfo[NSDeletedObjectsKey], filtering: T.self)

                    guard !(inserts.isEmpty && updates.isEmpty && deletes.isEmpty) else { continue }

                    continuation.yield((inserts: inserts, updates: updates, deletes: deletes))
                }

                continuation.finish()
            }

            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }


    // MARK: - Helpers

    private static func extractIDs<U: NSManagedObject>(_ any: Any?, filtering _: U.Type) -> Set<NSManagedObjectID> {
        let objects = (any as? Set<NSManagedObject>) ?? []
        return Set(objects.compactMap { $0 as? U }.map { $0.objectID })
    }
}
