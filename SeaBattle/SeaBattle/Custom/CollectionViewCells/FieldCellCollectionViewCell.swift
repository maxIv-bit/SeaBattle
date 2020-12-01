//
//  FieldCellCollectionViewCell.swift
//  SeaBattle
//
//  Created by Maks on 01.12.2020.
//

import UIKit

final class FieldCellCollectionViewCell: CollectionViewCell {
    private lazy var selectionOverlay = UIView()
    private lazy var checkmarkImageView = UIImageView()
    
    override func configure() {
        attachViews()
        configureUI()
    }
    
    func configure(_ color: UIColor) {
        self.backgroundColor = color
    }
}

// MARK: - Private
private extension FieldCellCollectionViewCell {
    func attachViews() {

    }
    
    func configureUI() {
        
    }
}
