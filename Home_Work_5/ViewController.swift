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
    }
    @IBAction func pressLogin(_ sender: Any) {
        print("You press Login")
    }
    
    
}

