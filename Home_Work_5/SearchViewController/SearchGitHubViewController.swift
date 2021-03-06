//
//  SearchGitHubViewController.swift
//  Home_Work_5
//
//  Created by Mykhailo Romanovskyi on 27.06.2020.
//  Copyright © 2020 Mykhailo Romanovskyi. All rights reserved.
//

import UIKit

class SearchGitHubViewController: UIViewController {
    
    @IBOutlet weak var order: UISegmentedControl!
    @IBOutlet weak var language: UITextField!
    @IBOutlet weak var repositoryName: UITextField!
    @IBOutlet weak var avatarImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurPlaceholderForImageView()
    }
    
    @IBAction func startSearch(_ sender: Any) {
        let order: String
        guard let repositoryName = repositoryName.text, !repositoryName.isEmpty else {
            print("Its Empty, type name for search")
            return}
        
        guard let language = language.text, !language.isEmpty else {
            print("Its Empty, type language name")
            return }
        
        if self.order.selectedSegmentIndex == 0 {
            order = "asc"
        } else {
            order = "desc"
        }
        
        performSearchRepoRequest(searchRepositoriesRequest(repositoryName, language, order))
        
    }
    
    private func configurPlaceholderForImageView() {
        avatarImage.image = #imageLiteral(resourceName: "avatar-placeholder")
        avatarImage.layer.cornerRadius = (view.frame.width * 0.3) / 2
    }
    
    func searchRepositoriesRequest(_ name: String, _ language: String, _ order: String) -> URLRequest? {
        
        let scheme = "https"
        let host = "api.github.com"
        let searchRepoPath = "/search/repositories"
        let defaultHeaders = [
            "Content-Type" : "application/json",
            "Accept" : "application/vnd.github.v3+json"
        ]
        
        var urlComponents = URLComponents()
        
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = searchRepoPath
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: "\(name)+\(language):swift"),
            URLQueryItem(name: "order", value: "\(order)")
        ]
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        return request
    }
    
    private func performSearchRepoRequest(_ url: URLRequest?) {
        guard let urlRequest = url else {
            print("Url error")
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("no data received")
                return
            }
            
            guard let text = String(data: data, encoding: .utf8) else {
                print("data encoding failed")
                return
            }
            print("received data: \(text)")
        }
        dataTask.resume()
    }
}
