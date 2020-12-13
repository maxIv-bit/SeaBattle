//
//  RoomsTableViewCell.swift
//  SeaBattle
//
//  Created by Maks on 21.11.2020.
//

import UIKit

final class RoomsTableViewCell: TableViewCell {
    private lazy var titleLabel = UILabel()
    private lazy var firstUserImageView = UIImageView()
    private lazy var secondUserImageView = UIImageView()
    
    override func configure() {
        attachViews()
        configureUI()
    }
    
    func configure(name: String, usersCount: Int) {
        titleLabel.text = name.capitalized
        secondUserImageView.isHidden = usersCount < 2
    }
}

private extension RoomsTableViewCell {
    func attachViews() {
        [titleLabel, firstUserImageView, secondUserImageView].forEach(contentView.addSubview)
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().inset(36)
        }
        
        firstUserImageView.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.right).offset(10)
            $0.size.equalTo(CGSize(width: 25, height: 40))
            $0.centerY.equalToSuperview()
        }
        
        secondUserImageView.snp.makeConstraints {
            $0.left.equalTo(firstUserImageView.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 25, height: 40))
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-36)
        }
    }
    
    func configureUI() {
        titleLabel.textColor = UIColor.orange
        titleLabel.font = UIFont.systemFont(ofSize: 18.0)
        titleLabel.textAlignment = .center
        
        firstUserImageView.image = UIImage(named: "PirateShip")
        secondUserImageView.image = UIImage(named: "PirateShip")
    }
}
