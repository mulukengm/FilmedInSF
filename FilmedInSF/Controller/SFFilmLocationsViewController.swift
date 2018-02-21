//
//  SFFilmLocationsViewController.swift
//  FilmedInSF
//
//  Created by Muluken Gebremariam on 2/17/18.
//  Copyright © 2018 Muluken Gebremariam. All rights reserved.
//

import UIKit
import CoreData

class SFFilmLocationsViewController: UIViewController {
    
    let movieDBAPIMovieSearchBase = "https://api.themoviedb.org/3/search/movie"
    let movieDBAPIPosterImageDownloadBase = "http://image.tmdb.org/t/p/w500/"
    let movieDBAPIKey = "463aec85f343a8632b030dbe52d4b382";
    let sfFilmLocationsAPIBase = "https://data.sfgov.org/resource/wwmu-gmzc.json"

    var locations : [SFFilmLocation] = [SFFilmLocation]()

    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SFFilmLocation")

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "location", ascending: true)]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.dataController.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
        
    }()
    
    @IBOutlet weak var sortSegmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(SFFilmLocationCell.nib, forCellReuseIdentifier: SFFilmLocationCell.identifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 320
        messageLabel.isHidden = true
        
        do {
            try self.fetchedResultsController.performFetch()
            
            var hasLocations = false
            
            if let locations = fetchedResultsController.fetchedObjects {
                hasLocations = locations.count > 0
            }
            
            tableView.isHidden = !hasLocations
            
            if hasLocations {
                tableView.reloadData()
            }
            else {
                getFilmLocationsFromAPI()
            }
            
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - IB Action

    
    @IBAction func sortSegmentedControlValueChanged(_ sender: Any) {
        switch sortSegmentControl.selectedSegmentIndex {
        case 0:
            sortFilmLocations(with: "location", ascending: true)
        case 1:
            sortFilmLocations(with: "title", ascending: true)
        case 2:
            sortFilmLocations(with: "releaseYear", ascending: false)
        default:
            sortFilmLocations(with: "location", ascending: true)
        }
    }
    
    // MARK: - Data

    private func sortFilmLocations(with property: String, ascending: Bool) {
        fetchedResultsController.fetchRequest.sortDescriptors = [NSSortDescriptor(key: property, ascending: ascending)]
        do {
            try self.fetchedResultsController.performFetch()
            
            var hasLocations = false
            
            if let locations = fetchedResultsController.fetchedObjects {
                hasLocations = locations.count > 0
            }
            
            if hasLocations {
                tableView.reloadData()
            }
            
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }
    
    private func getFilmLocationsFromAPI() {
        activityIndicatorView.startAnimating()
        let urlString = sfFilmLocationsAPIBase;
        
        SFAPIClient.sharedInstance.fetchDataFromPath(path: urlString, cached: true) { (data, error) in
            self.activityIndicatorView.stopAnimating()

            if let data = data {
                do {
                    let resultsArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String : AnyObject]]
                    DispatchQueue.main.async {
                        self.persistFilmLocations(array: resultsArray!)
                    }
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            else if let error = error {
                print(error)
                DispatchQueue.main.async {
                    self.messageLabel.isHidden = false
                }
            }
        }
    }
    
    private func createFilmLocationEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.dataController.persistentContainer.viewContext
        
        guard let title = dictionary["title"] as? String,
            let location = dictionary["locations"] as? String,
            let releaseYear = dictionary["release_year"] as? String
            else {
                return nil;
        }
        
        if let filmLocationEntity = NSEntityDescription.insertNewObject(forEntityName: "SFFilmLocation", into: managedObjectContext) as? SFFilmLocation {
    
            filmLocationEntity.title = title
            filmLocationEntity.location = location
            filmLocationEntity.releaseYear = releaseYear
            filmLocationEntity.writer = dictionary["writer"] as? String
            filmLocationEntity.director = dictionary["director"] as? String
            filmLocationEntity.distributor = dictionary["distributor"] as? String
            filmLocationEntity.productionCompany = dictionary["production_company"] as? String
    
            var actorCount = 1
            var actorsListString = ""
            while let actor = dictionary["actor_\(actorCount)"] as? String {
                actorsListString.append(actor + "\n")
                actorCount += 1
            }
    
            if actorsListString.count > 0 {
                filmLocationEntity.actors = actorsListString
            }
            
            return filmLocationEntity
        }
        return nil
    }
    
    private func persistFilmLocations(array: [[String: AnyObject]]) {
        _ = array.map{self.createFilmLocationEntityFrom(dictionary: $0)}
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        do {
            try appDelegate.dataController.persistentContainer.viewContext.save()
            do {
                try self.fetchedResultsController.performFetch()
            } catch {
                let fetchError = error as NSError
                print("Unable to Perform Fetch Request")
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
            self.updateView()
        } catch let error {
            print(error)
        }
    }
    
    // MARK :- View helpers
    
    private func updateView() {
        var hasLocations = false

        if let locations = fetchedResultsController.fetchedObjects {
            hasLocations = locations.count > 0
        }
        
        tableView.isHidden = !hasLocations
        tableView.reloadData()
        messageLabel.isHidden = hasLocations
    }
}

extension SFFilmLocationsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller: SFPageViewController? = storyboard?.instantiateViewController(withIdentifier: "SFPageViewController") as? SFPageViewController
        controller?.locations = fetchedResultsController.fetchedObjects as! [SFFilmLocation]
        controller?.locationIndex = indexPath.row
        navigationController?.pushViewController(controller!, animated: true)
    }
}

extension SFFilmLocationsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let filmLocations = fetchedResultsController.fetchedObjects else { return 0 }
        return filmLocations.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let location = fetchedResultsController.object(at: indexPath) as! SFFilmLocation
        let cell = tableView.dequeueReusableCell(withIdentifier: SFFilmLocationCell.identifier, for: indexPath) as! SFFilmLocationCell
        cell.locationLabel.text = location.location
        cell.movieTitleLabel.text = location.title?.uppercased()
        cell.releaseYearLabel.text = location.releaseYear
        
        return cell
    }
}

