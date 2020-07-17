//
//  CatCell.swift
//  CoreDataDemo5New
//
//  Created by Alex Nagy on 17/07/2020.
//  Copyright © 2020 Alex Nagy. All rights reserved.
//

import UIKit
import SparkUI
import Layoutless

class CatCell: TableCell<Cat>, SelfConfiguringCell {
    
    static var reuseIdentifier: String = "cell"
    
    let catImageView = UIImageView().circular(45).contentMode(.scaleAspectFill).masksToBounds()
    let nameLabel = UILabel().text(color: .systemBlack).bold(24)
    let votesLabel = UILabel().text(color: .systemGreen).bold(24)
    
    override func layoutViews() {
        super.layoutViews()
        
        stack(.horizontal, spacing: 12)(
            catImageView,
            nameLabel,
            votesLabel
            ).insetting(leftBy: 24, rightBy: 24, topBy: 5, bottomBy: 5).fillingParent().layout(in: container)
    }

    override func configureViews(for item: Cat?) {
        super.configureViews(for: item)
        
        guard let item = item else { return }
        
        nameLabel.text = item.name
        votesLabel.text = "\(item.votes)"
        
        guard let imageName = item.imageName else { return }
        catImageView.image = UIImage(named: imageName)
    }
}
