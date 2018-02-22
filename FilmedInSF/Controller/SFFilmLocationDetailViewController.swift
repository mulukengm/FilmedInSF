//
//  SFFilmLocationDetailViewController.swift
//  FilmedInSF
//
//  Created by Muluken Gebremariam on 2/18/18.
//  Copyright © 2018 Muluken Gebremariam. All rights reserved.
//

import UIKit
import MapKit

class SFFilmLocationDetailViewController: UIViewController {
    var location: SFFilmLocation?

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var castHeaderLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var productionCampanyLabel: UILabel!
    @IBOutlet weak var distributorLabel: UILabel!
    
    var searchResponse: MKLocalSearchResponse?
    let sfRegionCenterCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        displayDetails()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(sfRegionCenterCoordinate, 12000 , 12000)
        mapView.showsUserLocation = true
        mapView.showsPointsOfInterest = true
        mapView.isUserInteractionEnabled = true
        mapView.setRegion(region, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Logic

    private func displayDetails(){
        if let displayedLocation = self.location {
            self.locationLabel.text = displayedLocation.location
            self.movieTitleLabel.text = displayedLocation.title?.uppercased()
            self.releaseYearLabel.text = displayedLocation.releaseYear

            let normalAttrs = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15), NSAttributedStringKey.foregroundColor : UIColor.lightGray]
            let boldAttrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedStringKey.foregroundColor : UIColor.white]
            
            if let director = displayedLocation.director {
                let normalTxt = NSMutableAttributedString(string:director, attributes:normalAttrs)
                let boldTxt = NSMutableAttributedString(string:"Director  ", attributes:boldAttrs)
                boldTxt.append(normalTxt)
                self.directorLabel.attributedText = boldTxt
            }

            if let writer = displayedLocation.writer {
                let normalTxt = NSMutableAttributedString(string:writer, attributes:normalAttrs)
                let boldTxt = NSMutableAttributedString(string:"Writer  ", attributes:boldAttrs)
                boldTxt.append(normalTxt)
                self.writerLabel.attributedText = boldTxt
            }
            
            if let productionCompany = displayedLocation.productionCompany {
                let normalTxt = NSMutableAttributedString(string:productionCompany, attributes:normalAttrs)
                let boldTxt = NSMutableAttributedString(string:"Production  ", attributes:boldAttrs)
                boldTxt.append(normalTxt)
                self.productionCampanyLabel.attributedText = boldTxt
            }

            if let distributor = displayedLocation.distributor {
                let normalTxt = NSMutableAttributedString(string:distributor, attributes:normalAttrs)
                let boldTxt = NSMutableAttributedString(string:"Distributor  ", attributes:boldAttrs)
                boldTxt.append(normalTxt)
                self.distributorLabel.attributedText = boldTxt
            }
            
            if let actors = displayedLocation.actors {
                self.castLabel.text = actors
                self.castHeaderLabel.text = "Cast"
            }
            else {
                self.castLabel.text = nil
                self.castHeaderLabel.text = nil
            }
            
        }
    }
    
    func performSearch(withText query: String, region: MKCoordinateRegion) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = query
        request.region = region
        let search = MKLocalSearch(request: request)
        
        search.start(completionHandler: {(response,error) in
            if error == nil {
                self.searchResponse = response
                var placemarks = [MKAnnotation]()
                for item: MKMapItem in (self.searchResponse?.mapItems)! {
                    placemarks.append(item.placemark)
                }
                
                self.mapView.showAnnotations([placemarks.first] as? [MKAnnotation] ?? [MKAnnotation](), animated: true)
            }
        })
    }
    
}

extension SFFilmLocationDetailViewController : MKMapViewDelegate {
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {

    }

    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        if let displayedLocation = self.location {
            let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(self.sfRegionCenterCoordinate, 12000 , 12000)
            self.performSearch(withText: displayedLocation.location!, region: region)
        }
    }
}
