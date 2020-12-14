//
//  BattleFieldCell.swift
//  SeaBattle
//
//  Created by Maks on 10.12.2020.
//

import UIKit

final class BattleFieldCell: CollectionViewCell {
    private lazy var imageView = UIImageView()
    private(set) var x = 0
    private(set) var y = 0
    private(set) var isShot = false
    
    override func configure() {
        attachViews()
        configureUI()
    }
    
    func configure(x: Int, y: Int, isShot: Bool) {
        self.x = x
        self.y = y
        self.isShot = isShot
        imageView.isHidden = !isShot
    }
}

//  MARK: - Private
private extension BattleFieldCell {
    func attachViews() {
        [imageView].forEach(addSubview)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
    }
    
    func configureUI() {
        self.layer.addShadow(to: [.top, .bottom, .left, .right], radius: 1.0, opacity: 0.5, color: UIColor.black.cgColor)
        self.backgroundColor = .white
        self.imageView.image = UIImage(named: "redCircle")
    }
}
