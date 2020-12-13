//
//  BattleFieldCellView.swift
//  SeaBattle
//
//  Created by Maks on 10.12.2020.
//

import UIKit

final class BattleFieldCellView: View {
    private lazy var imageView = UIImageView()
    var x: Int
    var y: Int
    var isShot: Bool
    
    init(x: Int, y: Int, isShot: Bool, frame: CGRect) {
        self.x = x
        self.y = y
        self.isShot = isShot
        
        super.init(frame: frame)
        
        self.imageView.isHidden = !isShot
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        attachViews()
        configureUI()
    }
}

//  MARK: - Private
private extension BattleFieldCellView {
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
