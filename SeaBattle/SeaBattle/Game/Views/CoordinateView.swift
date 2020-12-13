//
//  CoordinateView.swift
//  SeaBattle
//
//  Created by Maks on 13.12.2020.
//

import UIKit

final class CoordinateView: View {
    private lazy var label = UILabel()
    
    override func configure() {
        attachViews()
        configureUI()
    }
    
    func configure(text: String) {
        label.text = text
    }
}

//  MARK: - Private
private extension CoordinateView {
    func attachViews() {
        [label].forEach(addSubview)
        
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureUI() {
        label.textColor = .blue
        label.textAlignment = .center
        self.layer.addShadow(to: [.top, .bottom, .left, .right], radius: 1.0, opacity: 0.5, color: UIColor.black.cgColor)
        self.backgroundColor = .white
    }
}
