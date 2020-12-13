//
//  BattleFieldView.swift
//  SeaBattle
//
//  Created by Maks on 10.12.2020.
//

import UIKit

final class BattleFieldCellView: UIView {
    var x: Int
    var y: Int
    
    init(x: Int, y: Int, frame: CGRect) {
        self.x = x
        self.y = y
        
        super.init(frame: frame)
        
        self.layer.addShadow(to: [.top, .bottom, .left, .right], radius: 3.0, opacity: 0.3, color: UIColor.gray.cgColor)
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
