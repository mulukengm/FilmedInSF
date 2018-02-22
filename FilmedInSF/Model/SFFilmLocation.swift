//
//  SFFilmLocation.swift
//  FilmedInSF
//
//  Created by Muluken Gebremariam on 2/17/18.
//  Copyright © 2018 Muluken Gebremariam. All rights reserved.
//

import UIKit
import CoreData

@objc(SFFilmLocation)
class SFFilmLocation: NSManagedObject {

    @NSManaged var title: String?
    @NSManaged var location: String?
    @NSManaged var releaseYear: String?
    @NSManaged var writer: String?
    @NSManaged var director: String?
    @NSManaged var productionCompany: String?
    @NSManaged var distributor: String?
    @NSManaged var actors: String?    
}
