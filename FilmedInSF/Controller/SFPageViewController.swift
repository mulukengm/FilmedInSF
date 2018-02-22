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
    var date: Date?
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        addBackButton()
        
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
    
    // MARK: - Logic

    func addBackButton(){
        let backButton = UIButton.init(type: .custom)
        backButton.frame = CGRect(x: 0, y: 18, width: 56, height: 56)
        backButton.setImage(UIImage.init(named: "circleBackButton"), for: .normal)
        backButton.addTarget(self, action:#selector(backAction(sender:)), for: .touchUpInside)
        self.view.addSubview(backButton)
    }
    
    @objc func backAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
