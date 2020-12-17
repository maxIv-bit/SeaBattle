//
//  GameView.swift
//  SeaBattle
//
//  Created by Maks on 13.12.2020.
//

import UIKit

final class GameView: View {
    private lazy var xCoordinates = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
    private lazy var xCoordinateViews = [CoordinateView]()
    private lazy var yCoordinateViews = [CoordinateView]()
    private lazy var battleFieldView = BattleFieldView()
    
    // MARK: - Callbacks
    var didShootPositionAt: ((IndexPath) -> Void)?
    var didUpdateBoatPositions: ((String, [Position]) -> Void)?
    var didShootBoatAtPosition: ((String, Position) -> Void)?
    var isAbleToShoot: (() -> Bool)?
    var isAbleToChangePositions: (() -> Bool)?
    var shouldShowBoats: (() -> Bool)?
    var onFirstBoatFrame: ((CGRect) -> Void)?
    
    override func configure() {
        configureBindings()
    }
    
    override func performOnceOnLayoutSubviews() {
        let width = self.bounds.width / 11
        let height = self.bounds.height / 11
        
        for i in 1...10 {
            let xFrame = CGRect(x: CGFloat(i) * width, y: 0, width: width, height: height)
            let xCoordinateView = CoordinateView(frame: xFrame)
            xCoordinateView.configure(text: xCoordinates[i - 1])
            self.xCoordinateViews.append(xCoordinateView)
            self.addSubview(xCoordinateView)
            
            let yFrame = CGRect(x: 0, y: CGFloat(i) * height, width: width, height: height)
            let yCoordinateView = CoordinateView(frame: yFrame)
            yCoordinateView.configure(text: "\(i)")
            self.yCoordinateViews.append(yCoordinateView)
            self.addSubview(yCoordinateView)
        }
    }
    
    func configure(with boats: [Boat], positions: [Position]) {
        let width = self.bounds.width / 11
        let height = self.bounds.height / 11
        
        battleFieldView.frame = CGRect(origin: CGPoint(x: width, y: height), size: CGSize(width: bounds.width - width, height: bounds.height - height))
        addSubview(battleFieldView)
        battleFieldView.configure(with: boats, positions: positions)
    }
    
    func update(positions: [Position]) {
        battleFieldView.update(positions: positions)
    }
    
    func update(boat: Boat, isShot: Bool, animate: Bool) {
        battleFieldView.update(boat: boat, isShot: isShot, animate: animate)
    }
}

//  MARK: - Private
private extension GameView {
    func configureBindings() {
        battleFieldView.didShootPositionAt = { [weak self] indexPath in
            self?.didShootPositionAt?(indexPath)
        }
        
        battleFieldView.didUpdateBoatPositions = { [weak self] boatId, positions in
            self?.didUpdateBoatPositions?(boatId, positions)
        }
        
        battleFieldView.didShootBoatAtPosition = { [weak self] boatId, position in
            self?.didShootBoatAtPosition?(boatId, position)
        }
        
        battleFieldView.isAbleToShoot = { [weak self] in
            self?.isAbleToShoot?() ?? false
        }
        
        battleFieldView.isAbleToChangePositions = { [weak self] in
            self?.isAbleToChangePositions?() ?? false
        }
        
        battleFieldView.shouldShowBoats = { [weak self] in
            self?.shouldShowBoats?() ?? false
        }
        
        battleFieldView.onFirstBoatFrame = { [weak self] frame in
            guard let self = self else { return }
            var frame = frame
            frame.x += self.frame.x
            frame.y += self.frame.y
            self.onFirstBoatFrame?(frame)
        }
    }
}
