//
//  BattleFieldView.swift
//  SeaBattle
//
//  Created by Maks on 13.12.2020.
//

import UIKit

private struct Constants {
    static var cellPadding: CGFloat { 2.0 }
}

final class BattleFieldView: View {
    private lazy var battleFieldCellViews = [BattleFieldCellView]()
    private lazy var boatViews = [BoatView]()
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizer))
    
    // MARK: - Callback
    var didTapOnPosition: ((CGPoint) -> Void)?
    
    override func configure() {
        addGestureRecognizer(tapGesture)
    }
    
    func configure(with boats: [Boat], positions: [Position]) {
        battleFieldCellViews.forEach { $0.removeFromSuperview() }
        battleFieldCellViews.removeAll()
        boatViews.forEach { $0.removeFromSuperview() }
        boatViews.removeAll()
        
        let cellWidth: CGFloat = self.bounds.width / 10
        let cellHeight: CGFloat = self.bounds.height / 10
        
        DispatchQueue.global().async {
            for position in positions {
                let frame = CGRect(x: CGFloat(position.x - 1) * cellWidth, y: CGFloat(position.y - 1) * cellHeight, width: cellWidth, height: cellHeight)
                DispatchQueue.main.async {
                    let newView = BattleFieldCellView(x: position.x, y: position.y, isShot: position.isShot, frame: frame)
                    self.battleFieldCellViews.append(newView)
                    self.addSubview(newView)
                }
            }
            
            for boat in boats.sorted(by: { $0.positions.values.first?.x ?? 0 < $1.positions.values.first?.x ?? 0 }) {
                let boatPositions = boat.positions.values.sorted(by: { $0.x < $1.x || $0.y < $1.y }).map { Position(x: $0.x, y: $0.y, isShot: $0.isHurt) }
                let first = boatPositions.first!
                var width: CGFloat = cellWidth
                var height: CGFloat = cellHeight
                if boatPositions.count > 1 {
                    if Set(boatPositions.map({ $0.x })).count > Set(boatPositions.map({ $0.y })).count {
                        width = CGFloat(boatPositions.count) * width
                    } else {
                        height = CGFloat(boatPositions.count) * height
                    }
                }
                let frame = CGRect(x: CGFloat(first.x - 1) * cellWidth, y: CGFloat(first.y - 1) * cellHeight, width: Constants.cellPadding + width, height: Constants.cellPadding + height)
                let insetFrame = frame.insetBy(dx: Constants.cellPadding, dy: Constants.cellPadding)
                DispatchQueue.main.async {
                    let newView = BoatView(boat: boat, frame: insetFrame)
                    self.boatViews.append(newView)
                    self.addSubview(newView)
                }
            }
        }
    }
    
    @objc func tapGestureRecognizer(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        let cellWidth: CGFloat = self.bounds.width / 10
        let cellHeight: CGFloat = self.bounds.height / 10
        
        didTapOnPosition?(CGPoint(x: Int(location.x / cellWidth) + 1, y: Int(location.y / cellHeight) + 1))
    }
}
