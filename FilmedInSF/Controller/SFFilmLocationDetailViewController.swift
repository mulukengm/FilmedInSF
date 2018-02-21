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
    //let sfLatitute:
    let sfRegionCenterCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        displayDetails()

        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    private func displayDetails(){
        if let displayedLocation = self.location {
            self.locationLabel.text = displayedLocation.location
            self.movieTitleLabel.text = displayedLocation.title
            self.releaseYearLabel.text = displayedLocation.releaseYear
            self.directorLabel.text = displayedLocation.director
            self.writerLabel.text = displayedLocation.writer
            self.productionCampanyLabel.text = displayedLocation.productionCompany
            self.distributorLabel.text = displayedLocation.distributor
            
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
    
    func removeAllPinsButUserLocation() {
        let pins : [MKAnnotation] = mapView.annotations
        mapView.removeAnnotations(pins)
    }
    
    func annotation(with location: CLLocation) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        return annotation
    }
}

extension SFFilmLocationDetailViewController : MKMapViewDelegate {
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(sfRegionCenterCoordinate, 12000 , 12000)
        mapView.showsUserLocation = true
        mapView.showsPointsOfInterest = true
        mapView.isUserInteractionEnabled = true
        mapView.setRegion(region, animated: true)
    }

    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        if let displayedLocation = self.location {
            
            let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(self.sfRegionCenterCoordinate, 12000 , 12000)
            self.performSearch(withText: displayedLocation.location!, region: region)
//            let when = DispatchTime.now() + 4
//            DispatchQueue.main.asyncAfter(deadline: when, execute: {
//                let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(self.sfRegionCenterCoordinate, 12000 , 12000)
//                self.performSearch(withText: displayedLocation.location!, region: region)
//            })
//            
            
        }
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//    }

}
