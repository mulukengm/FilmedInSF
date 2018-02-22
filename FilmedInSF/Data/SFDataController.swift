//
//  SFDataHelper.swift
//  FilmedInSF
//
//  Created by Muluken Gebremariam on 2/19/18.
//  Copyright © 2018 Muluken Gebremariam. All rights reserved.
//

import UIKit
import CoreData

class SFDataController: NSObject {
    var persistentContainer: NSPersistentContainer
    
    init(completionClosure: @escaping () -> ()) {
        persistentContainer = NSPersistentContainer(name: "FilmedInSF")
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            completionClosure()
        }
    }
}
