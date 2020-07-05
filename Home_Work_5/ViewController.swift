//
//  ViewController.swift
//  Home_Work_5
//
//  Created by Mykhailo Romanovskyi on 27.06.2020.
//  Copyright © 2020 Mykhailo Romanovskyi. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    let url = URL(string: "https://github.com/MichaelRoma/githubLogo/raw/master/githubLogo.png")
    override func viewDidLoad() {
        super.viewDidLoad()
        imageAvatar.kf.setImage(with: url)
    }
    @IBAction func pressLogin(_ sender: Any) {
        getUserInformation()
    }
    
    func getUserInformation() {
        
        guard let username = username.text else {
            print("No username, please type it")
            return
        }
        
        guard let password = password.text else {
            print("No password, please type it")
            return
        }
        
        guard let myUrl = URL(string: "https://api.github.com/user") else { return }
        var myRequest = URLRequest(url: myUrl)
        
        let userInfo = "\(username):\(password)".data(using: .utf8)?.base64EncodedString() ?? ""
        
        myRequest.addValue("Basic \(userInfo)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: myRequest) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else {
                print("no data received")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(JsonModel.Owner.self
                    , from: data)
                print(model)
                guard let url = URL(string: model.avatar_url) else { return }
                print(url)
                DispatchQueue.main.async {
                    let pushView = SearchGitHubViewController()
                    pushView.url = url
                    pushView.name = model.login
                    self.navigationController?.pushViewController(pushView, animated: true)
                }
            } catch let error {
                print(error.localizedDescription)
                
                let alert = UIAlertController(title: "Attension", message: "You using two-factor authentication. This app cant handl it. So, or turn it off, or close this app", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
            }
        }.resume()
    }
}

