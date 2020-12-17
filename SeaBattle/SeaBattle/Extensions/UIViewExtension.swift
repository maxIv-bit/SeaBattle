//
//  UIViewExtension.swift
//  SeaBattle
//
//  Created by Maks on 06.12.2020.
//

import UIKit

extension UIView {
    func toImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func animatePath(from: CGPath?, to: CGPath?, animationDuration: CFTimeInterval, assignToLayer: CAShapeLayer, completion: (() -> Void)?) {
        layer.mask = assignToLayer
        
        let anim = CABasicAnimation(keyPath: "path")
        anim.fromValue = from
        anim.toValue = to
        anim.duration = animationDuration
        
        assignToLayer.add(anim, forKey: "path")
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        CATransaction.setCompletionBlock({
          completion?()
        })
        assignToLayer.path = to
        CATransaction.commit()
    }
}
