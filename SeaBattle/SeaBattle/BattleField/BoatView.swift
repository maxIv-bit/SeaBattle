//
//  BoatView.swift
//  SeaBattle
//
//  Created by Maks on 10.12.2020.
//

import UIKit

final class BoatView: UIView {
    var boat: Boat
    var lastLocation = CGPoint(x: 0, y: 0)
    
    init(boat: Boat, frame: CGRect) {
        self.boat = boat
        
        super.init(frame: frame)
        
        let panRecognizer = UIPanGestureRecognizer(target:self, action:#selector(detectPan))
        self.gestureRecognizers = [panRecognizer]
        
        self.backgroundColor = .red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func detectPan(_ recognizer:UIPanGestureRecognizer) {
        let translation  = recognizer.translation(in: self.superview)
        self.center = CGPoint(x: lastLocation.x + translation.x, y: lastLocation.y + translation.y)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.superview?.bringSubviewToFront(self)

        lastLocation = self.center
    }
}
