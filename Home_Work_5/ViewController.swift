//
//  ViewController.swift
//  Home_Work_5
//
//  Created by Mykhailo Romanovskyi on 27.06.2020.
//  Copyright © 2020 Mykhailo Romanovskyi. All rights reserved.
//

import UIKit
import Kingfisher
import LocalAuthentication

class ViewController: UIViewController {
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    let a = KeyChainModel()
    
    
    let url = URL(string: "https://github.com/MichaelRoma/githubLogo/raw/master/githubLogo.png")
    override func viewDidLoad() {
        super.viewDidLoad()
        imageAvatar.kf.setImage(with: url)
    }
    
    @IBAction func pressLogin(_ sender: Any) {
        guard let username = username.text else {
            print("No username, please type it")
            return
        }
        
        guard let password = password.text else {
            print("No password, please type it")
            return
        }
       // a.savePassword(password: password, account: username)
      //  authenticateUser()
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
        
        URLSession.shared.dataTask(with: myRequest) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                      print("http status code: \(httpResponse.statusCode)")
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

// MARK: User authenticate
extension ViewController {
    
    func authenticateUser() {
        
        if #available(iOS 8.0, *, *) {
            let authenticationContext = LAContext()
            setupAuthenticationContext(context: authenticationContext)
            
            let reason = "Fast and safe authentication in your app"
            var authError: NSError?
            
            if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                    [unowned self] success, evaluateError in
                    if success {
                        // Пользователь успешно прошел аутентификацию
                        
                        self.startMainApplicationFlow()
                    } else {
                        // Пользователь не прошел аутентификацию
                        
                        if let error = evaluateError {
                            print(error.localizedDescription)
                        }
                    }
                }
            } else {
                // Не удалось выполнить проверку на использование биометрических данных или пароля для аутентификации
                
                if let error = authError {
                    print(error.localizedDescription)
                }
            }
        } else {
            // Более рання версия iOS macOS
        }
    }
    
    func startMainApplicationFlow() {
        print("Main application flow started")
    }
    func setupAuthenticationContext(context: LAContext) {
        context.localizedReason = "Use for fast and safe authentication in your app"
        context.localizedCancelTitle = "Cancel"
        context.localizedFallbackTitle = "Enter password"
        
        context.touchIDAuthenticationAllowableReuseDuration = 600
    }
}
