//
//  CollectionViewCell.swift
//  SeaBattle
//
//  Created by Maks on 01.12.2020.
//

import UIKit

class CollectionViewCell: UICollectionViewCell, Reusable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configure()
    }
    
    func configure() {}
}

