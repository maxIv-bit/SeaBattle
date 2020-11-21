//
//  UsersOnlineTableViewCell.swift
//  SeaBattle
//
//  Created by Maks on 21.11.2020.
//

import UIKit

final class UsersOnlineTableViewCell: TableViewCell {
    private lazy var titleLabel = UILabel()
    
    override func configure() {
        attachViews()
        configureUI()
    }
    
    func configure(email: String) {
        titleLabel.text = email
    }
}

private extension UsersOnlineTableViewCell {
    func attachViews() {
        [titleLabel].forEach(contentView.addSubview)
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(36)
        }
    }
    
    func configureUI() {
        titleLabel.textColor = UIColor.orange
        titleLabel.font = UIFont.systemFont(ofSize: 18.0)
        titleLabel.textAlignment = .center
    }
}
