//
//  Cell.swift
//  Home_Work_5
//
//  Created by Mykhailo Romanovskyi on 01.07.2020.
//  Copyright © 2020 Mykhailo Romanovskyi. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var repositoriesName: UILabel!
    @IBOutlet weak var cellDescription: UILabel!
    @IBOutlet weak var autorName: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
}

extension SearchTableViewCell {
    func cellConfigurator(with repoInfo: JsonModel.Items ) {
        repositoriesName.text = repoInfo.name
        cellDescription.text = repoInfo.description
        autorName.text = repoInfo.owner.login
        guard let url = URL(string: repoInfo.owner.avatar_url) else { return }
        avatar.kf.setImage(with: url)
    }
}
