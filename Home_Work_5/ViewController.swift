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
    
    let url = URL(string: "https://github.com/MichaelRoma/githubLogo/raw/master/githubLogo.png")
    override func viewDidLoad() {
        super.viewDidLoad()
        imageAvatar.kf.setImage(with: url)
        keyboardDismis()
    }
    @IBAction func pressLogin(_ sender: Any) {
        navigationController?.pushViewController(SearchGitHubViewController(), animated: true)
    }
    private func keyboardDismis() {
          let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
                 view.addGestureRecognizer(tap)
      }
}

