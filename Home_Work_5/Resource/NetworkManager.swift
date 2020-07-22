//
//  NetworkManager.swift
//  Home_Work_5
//
//  Created by Mykhailo Romanovskyi on 08.07.2020.
//  Copyright © 2020 Mykhailo Romanovskyi. All rights reserved.
//
import Foundation
import UIKit

class NetworkManager {
    
    class func task(url: URLRequest, completion: @escaping ((Data?, URLResponse?, Error?) -> Void)) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    class func getData(url: URLRequest, completion: @escaping ((Result<JsonModel, Error>)
        ->Void)) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let model = try decoder.decode(JsonModel.self, from: data)
                    completion(.success(model))
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
}
