//
//  SFAPIClient.swift
//  Mopi
//
//  Created by Muluken Gebremariam on 2/8/18.
//  Copyright © 2018 Muluken Gebremariam. All rights reserved.
//

import Foundation
import UIKit

class SFAPIClient: NSObject {
    
    static let sharedInstance = SFAPIClient();
    let defaultURLSession = URLSession(configuration: .default)
    
    override private init() {}
    
    func fetchDataFromPath(path: String, cached: Bool, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        
        let url = URL(string: path)
        
        let dataTask: URLSessionDataTask? = defaultURLSession.dataTask(with:url!){ data, response, error in
            
            if let error = error {
                print("DataTask error: " + error.localizedDescription + "\n")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                DispatchQueue.main.async {
                    completion(data, nil)
                }
            }
        }
        
        dataTask?.resume()
        
    }

    
}
