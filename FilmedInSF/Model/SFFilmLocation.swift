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


    
//    init?(with dict:[String : Any]) {
//        guard let title = dict["title"] as? String,
//            let location = dict["locations"] as? String,
//            let releaseYear = dict["release_year"] as? String
//            else {
//                return nil;
//        }
//
//        self.title = title
//        self.location = location
//        self.releaseYear = releaseYear
//        self.writer = dict["writer"] as? String
//        self.director = dict["director"] as? String
//        self.distributor = dict["distributor"] as? String
//        self.productionCompany = dict["production_company"] as? String
//
//        var actorCount = 1
//        var actorsListString = ""
//        while let actor = dict["actor_\(actorCount)"] as? String {
//            actorsListString.append(actor + "\n")
//            actorCount += 1
//        }
//
//        if actorsListString.count > 0 {
//            self.actors = actorsListString
//        }
//
//
//    }
    
}
