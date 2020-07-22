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
    
    let keyChain = KeyChainModel()
    
    
    let url = URL(string: "https://github.com/MichaelRoma/githubLogo/raw/master/githubLogo.png")
    override func viewDidLoad() {
        super.viewDidLoad()
        imageAvatar.kf.setImage(with: url)
        keyboardDismis()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if keyChain.readAllItems() != nil{
            authenticateUser()
        }
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
        getUserInformation(username, password)
    }
    
    func getUserInformation(_ username: String, _ password: String) {
        
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
                if httpResponse.statusCode == 200 {
                    //Так как всегда должен быть только один пользователь и если нажать отмена биометрической аунтификации. ТО можно будет ввести данные нового пользователя, соответственно данные старого необходимо удалить.
                    _ = self.keyChain.deletePassword()
                    _ = self.keyChain.savePassword(password: password, account: username)
                }
            }
            guard let data = data else {
                print("no data received")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(JsonModel.Owner.self, from: data)
                guard let url = URL(string: model.avatar_url) else { return }
                DispatchQueue.main.async {
                    let pushView = SearchGitHubViewController()
                    pushView.url = url
                    pushView.name = model.login
                    self.navigationController?.pushViewController(pushView, animated: true)
                }
            } catch let error {
                print(error.localizedDescription)
                
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Attension", message: "You dont have access to GitHub. Try AGAIN", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }.resume()
    }
    private func keyboardDismis() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
}

// MARK: User authenticate
extension ViewController {
    
    private func authenticateUser() {
        
        if #available(iOS 8.0, *, *) {
            let authenticationContext = LAContext()
            setupAuthenticationContext(context: authenticationContext)
            
            let reason = "Fast and safe authentication in your app"
            var authError: NSError?
            
            if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                    [unowned self] success, evaluateError in
                    if success {
                        guard let userData = self.keyChain.readAllItems() else {
                            return
                        }
                        //В задании было указано, что удобней пользоваться JSON, но так как по задумке у нас всегда должена быть одна пара логин/пароль. я думаю вариант ниже удоюней
                        for (username, password) in userData {
                            print(username)
                            self.getUserInformation(username, password)}
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
    
    private  func setupAuthenticationContext(context: LAContext) {
        context.localizedReason = "Use for fast and safe authentication in your app"
        context.localizedCancelTitle = "Cancel"
        context.localizedFallbackTitle = "Enter password"
        
        context.touchIDAuthenticationAllowableReuseDuration = 600
    }
}
