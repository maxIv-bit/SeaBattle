//
//  UIEdgeInsetsExtension.swift
//  SeaBattle
//
//  Created by Maks on 04.12.2020.
//

import UIKit

extension UIEdgeInsets {
    var horizontal: CGFloat {
        return top + bottom
    }
    
    var vertical: CGFloat {
        return left + right
    }
    
    init(side: CGFloat) {
        self.init(top: side, left: side, bottom: side, right: side)
    }
}
