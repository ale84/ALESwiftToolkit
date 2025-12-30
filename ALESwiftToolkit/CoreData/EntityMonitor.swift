//
//  Created by Alessio on 04/08/2020
//  Copyright © 2020 Alessio Orlando. All rights reserved.
//


import Foundation
import CoreData

class EntityMonitor<T: NSManagedObject> {
    private(set) var managedObjectContext: NSManagedObjectContext
    
    private(set) var notificationCenter: NotificationCenter
    
    private(set) var changesHandler: ChangesHandler?
    
    let observingOption: ObservingOption
    
    init(with context: NSManagedObjectContext,
         observingOption: ObservingOption,
         notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.managedObjectContext = context
        self.observingOption = observingOption
        self.notificationCenter = notificationCenter
    }

    typealias EntityChanges = (
        inserts: Set<T>,
        updates: Set<T>,
        deletes: Set<T>
    )
    
    typealias ChangesHandler = ((EntityChanges) -> Void)
    
    func startMonitoring(changesHandler: @escaping ChangesHandler) {
        self.changesHandler = changesHandler
        
        notificationCenter.addObserver(self,
                                       selector: #selector(managedObjectContextDidChange(notification:)),
                                       name: observingOption.notificationName,
                                       object: managedObjectContext)
    }
    
    @objc private func managedObjectContextDidChange(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        let inserts = (userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> ?? []).filter { $0 is T } as! Set<T>
        let updates = (userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> ?? []).filter { $0 is T } as! Set<T>
        let deletes = (userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> ?? []).filter { $0 is T } as! Set<T>
        
        if inserts.count > 0 {
            Logger.debug("--- INSERTS ---")
            Logger.debug("\(inserts)")
            Logger.debug("+++++++++++++++")
        }
        
        if updates.count > 0 {
            Logger.debug("--- UPDATES ---")
            Logger.debug("\(updates)")
            Logger.debug("+++++++++++++++")
        }
        
        if deletes.count > 0 {
            Logger.debug("--- DELETES ---")
            Logger.debug("\(deletes)")
            Logger.debug("+++++++++++++++")
        }
        
        guard !(inserts.isEmpty && updates.isEmpty && deletes.isEmpty) else { return }
        
        let changes = EntityChanges(inserts: inserts, updates: updates, deletes: deletes)
        changesHandler?(changes)
    }
}

extension EntityMonitor {
    
    enum ObservingOption {
        case contextDidSave
        case objectChanges
    }
}

extension EntityMonitor.ObservingOption {
    var notificationName: Notification.Name {
        switch self {
        case .contextDidSave:
            return .NSManagedObjectContextDidSave
        case .objectChanges:
            return .NSManagedObjectContextObjectsDidChange
        }
    }
}
