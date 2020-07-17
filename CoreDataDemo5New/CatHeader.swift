//
//  CatHeader.swift
//  CoreDataDemo5New
//
//  Created by Alex Nagy on 17/07/2020.
//  Copyright © 2020 Alex Nagy. All rights reserved.
//

import UIKit
import SparkUI
import Layoutless

class CatHeader: TableSupplementaryView<String>, SelfConfiguringCell {
    
    static var reuseIdentifier: String = "header-cell"
    
    let titleLabel = UILabel().text(color: .systemBlack).bold()
    
    override func layoutViews() {
        super.layoutViews()
        
        stack(.horizontal)(
            titleLabel,
            Spacer()
            ).insetting(leftBy: 24, rightBy: 24, topBy: 0, bottomBy: 0).fillingParent().layout(in: container)
        
    }
    
    override func configureViews(for item: String?) {
        super.configureViews(for: item)
        guard let item = item else { return }
        
        titleLabel.text = item
        setSupplementaryViewBackgroundColor(all: .systemGray5)
    }
}

