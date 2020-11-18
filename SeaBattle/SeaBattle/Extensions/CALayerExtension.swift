//
//  CALayerExtension.swift
//  SeaBattle
//
//  Created by Maks on 17.11.2020.
//

import UIKit

extension CALayer {
    func setBorder(fillColor: CGColor = UIColor.clear.cgColor, strokeColor: CGColor = UIColor.black.cgColor, lineWidth: CGFloat) {
        let layer = CAShapeLayer()
        layer.path = CGPath(rect: self.bounds, transform: nil)
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.black.cgColor
        layer.lineWidth = lineWidth
        self.addSublayer(layer)
    }
}
