//
//  FieldCellCollectionViewCell.swift
//  SeaBattle
//
//  Created by Maks on 01.12.2020.
//

import UIKit

final class FieldCellCollectionViewCell: CollectionViewCell {
    private lazy var titleLabel = UILabel()
    
    override func configure() {
        attachViews()
        configureUI()
    }
    
    func configure(_ color: UIColor, indexPath: IndexPath, axis: String) {
        self.backgroundColor = color
//        titleLabel.text = "\(indexPath.row)"
        titleLabel.text = axis
    }
}

// MARK: - Private
private extension FieldCellCollectionViewCell {
    func attachViews() {
        [titleLabel].forEach(contentView.addSubview)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureUI() {
        
    }
}
