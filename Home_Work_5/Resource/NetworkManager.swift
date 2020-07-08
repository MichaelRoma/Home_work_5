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
}
