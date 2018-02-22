//
//  SFPageViewController.swift
//  FilmedInSF
//
//  Created by Muluken Gebremariam on 2/18/18.
//  Copyright © 2018 Muluken Gebremariam. All rights reserved.
//

import UIKit

class SFPageViewController: UIPageViewController, UIPageViewControllerDelegate {
    
    var locations = [SFFilmLocation]()
    var locationIndex: Int?
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        if let currentLocationIndex = locationIndex {
            if locations.indices.contains(currentLocationIndex) {
                let location = locations[currentLocationIndex]
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller: SFFilmLocationDetailViewController = storyboard.instantiateViewController(withIdentifier: "SFFilmLocationDetailViewController") as! SFFilmLocationDetailViewController
                controller.location = location
                
                setViewControllers([controller], direction: .forward, animated: true, completion: nil)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension SFPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let filmLocationDetailViewController = viewController as! SFFilmLocationDetailViewController
        
        guard let location = filmLocationDetailViewController.location else {
            return nil
        }
        
        guard let locationIndex = self.locations.index(of: location) else {
            return nil
        }
        
        let previousLocationIndex = locationIndex - 1
        
        guard self.locations.count > previousLocationIndex,
            previousLocationIndex >= 0
            else {
                return nil
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: SFFilmLocationDetailViewController = storyboard.instantiateViewController(withIdentifier: "SFFilmLocationDetailViewController") as! SFFilmLocationDetailViewController
        controller.location = locations[previousLocationIndex]
        
        return controller
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let locationDetailViewController = viewController as! SFFilmLocationDetailViewController
        
        guard let location = locationDetailViewController.location else {
            return nil
        }
        
        guard let locationIndex = self.locations.index(of: location) else {
            return nil
        }
        
        let nextLocationIndex = locationIndex + 1
        
        guard self.locations.count > nextLocationIndex,
            nextLocationIndex >= 0
            else {
                return nil
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: SFFilmLocationDetailViewController = storyboard.instantiateViewController(withIdentifier: "SFFilmLocationDetailViewController") as! SFFilmLocationDetailViewController
        controller.location = locations[nextLocationIndex]
        
        return controller
    }
}
