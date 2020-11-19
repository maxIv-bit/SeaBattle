//
//  CALayerExtension.swift
//  SeaBattle
//
//  Created by Maks on 17.11.2020.
//

import UIKit

extension CALayer {
    func setBorder(fillColor: CGColor = UIColor.clear.cgColor, strokeColor: CGColor = UIColor.black.cgColor, lineWidth: CGFloat, cornerRadius: CGFloat = 10) {
        let layer = CAShapeLayer()
        layer.path = CGPath(roundedRect: self.bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.black.cgColor
        layer.lineWidth = lineWidth
        self.addSublayer(layer)
    }
    
    func setGradient(colors: [CGColor], locations: [NSNumber]) -> CAGradientLayer? {
        let layer = CAGradientLayer()
        layer.frame = self.bounds
        layer.colors = colors
        layer.locations = locations
        layer.startPoint = CGPoint(x: 0.0, y: 0.5)
        self.addSublayer(layer)
        return layer
    }
    
    func animateGradient() {
        let animation = CABasicAnimation(keyPath: "startPoint")
        animation.duration = 2.0
        animation.fromValue = CGPoint(x: 0.0, y: 0.5)
        animation.toValue = CGPoint(x: 1.0, y: 0.5)
        animation.repeatCount = Float.infinity
        animation.autoreverses = true
        self.add(animation, forKey: nil)
    }
    
    func addText(_ text: String, color: CGColor, alignmentMode: CATextLayerAlignmentMode = .center, fontSize: CGFloat) {
        let layer = CATextLayer()
        layer.frame = self.bounds
        layer.string = text
        layer.foregroundColor = color
        layer.alignmentMode = alignmentMode
        layer.fontSize = fontSize
        self.addSublayer(layer)
    }
}

