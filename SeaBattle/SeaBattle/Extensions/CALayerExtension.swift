//
//  CALayerExtension.swift
//  SeaBattle
//
//  Created by Maks on 17.11.2020.
//

import UIKit

extension CALayer {
    func setBorder(fillColor: CGColor = UIColor(white: 1.0, alpha: 0.6).cgColor, strokeColor: CGColor = UIColor.black.cgColor, lineWidth: CGFloat, cornerRadius: CGFloat = 10) {
        let layer = CAShapeLayer()
        layer.path = CGPath(roundedRect: self.bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
        layer.fillColor = fillColor
        layer.strokeColor = strokeColor
        layer.lineWidth = lineWidth
        self.addSublayer(layer)
    }
    
    func setGradient(colors: [CGColor], locations: [NSNumber]) -> CAGradientLayer? {
        let layer = CAGradientLayer()
        layer.frame = self.bounds
        layer.colors = colors
        layer.locations = locations
        layer.cornerRadius = 10.0
        layer.startPoint = CGPoint(x: 0.0, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.addSublayer(layer)
        return layer
    }
    
    func animateGradient(duration: CFTimeInterval = 2.0, fromValue: [Float], toValue: [Float]) {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.duration = duration
        animation.fromValue = fromValue
        animation.toValue = toValue
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
        layer.addShadow()
        self.addSublayer(layer)
    }
    
    func addShadow(color: CGColor = UIColor.black.cgColor, offset: CGSize = CGSize(width: 0.0, height: 6.0), opacity: Float = 0.6) {
        self.shadowColor = color
        self.shadowOpacity = opacity
        self.shadowOffset = offset
    }
    
    func addShadow(to edges: [UIRectEdge], radius: CGFloat = 3.0, opacity: Float = 0.6, color: CGColor = UIColor.black.cgColor) {
        let fromColor = color
        let toColor = UIColor.clear.cgColor
        let viewFrame = self.frame
        for edge in edges {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [fromColor, toColor]
            gradientLayer.opacity = opacity

            switch edge {
            case .top:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
                gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: viewFrame.width, height: radius)
            case .bottom:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
                gradientLayer.frame = CGRect(x: 0.0, y: viewFrame.height - radius, width: viewFrame.width, height: radius)
            case .left:
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
                gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: radius, height: viewFrame.height)
            case .right:
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
                gradientLayer.frame = CGRect(x: viewFrame.width - radius, y: 0.0, width: radius, height: viewFrame.height)
            default:
                break
            }
            self.addSublayer(gradientLayer)
        }
    }
}

