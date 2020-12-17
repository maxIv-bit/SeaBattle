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
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var dataSource = GameCollectionViewDataSource(collectionView: collectionView)
    private lazy var boatViews = [BoatView]()
    private lazy var gotBoatFrame = false
    
    // MARK: - Callback
    var didShootPositionAt: ((IndexPath) -> Void)?
    var didUpdateBoatPositions: ((String, [Position]) -> Void)?
    var didShootBoatAtPosition: ((String, Position) -> Void)?
    var isAbleToShoot: (() -> Bool)?
    var isAbleToChangePositions: (() -> Bool)?
    var shouldShowBoats: (() -> Bool)?
    var onFirstBoatFrame: ((CGRect) -> Void)?
    
    override func configure() {
        attachViews()
        configureUI()
        configureBindings()
    }
    
    func configure(with boats: [Boat], positions: [Position]) {
        dataSource.update(data: positions, shouldReload: true)
        
        let cellWidth: CGFloat = self.bounds.width / 10
        let cellHeight: CGFloat = self.bounds.height / 10
        
        DispatchQueue.global(qos: .userInitiated).async {
            for boat in boats.sorted(by: { $0.positions.values.first?.x ?? 0 < $1.positions.values.first?.x ?? 0 }) {
                self.getBoatFrame(boat: boat, cellWidth: cellWidth, cellHeight: cellHeight) { frame in
                    DispatchQueue.main.async {
                        let newView = BoatView(boat: boat, frame: frame, didUpdatePositions: self.didUpdateBoatPositions, didShootPosition: self.didShootBoatAtPosition, isAbleToShoot: self.isAbleToShoot, isAbleToChangePositions: self.isAbleToChangePositions, shouldShowBoat: self.shouldShowBoats?() ?? false)
                        self.boatViews.append(newView)
                        self.addSubview(newView)
                        
                        if !self.gotBoatFrame && boat.length == 4 {
                            var frame = frame
                            frame.x += self.frame.x
                            frame.y += self.frame.y
                            self.onFirstBoatFrame?(frame)
                            self.gotBoatFrame = true
                        }
                    }
                }
            }
        }
    }
    
    func update(positions: [Position]) {
        dataSource.update(data: positions, shouldReload: true)
    }
    
    func update(boat: Boat, isShot: Bool, animate: Bool) {
        guard let boatView = boatViews.first(where: { $0.boat == boat }) else { return }
        
        boatView.update(boat: boat)
        
        let cellWidth: CGFloat = self.bounds.width / 10
        let cellHeight: CGFloat = self.bounds.height / 10
        
        if !isShot {
            getBoatFrame(boat: boat, cellWidth: cellWidth, cellHeight: cellHeight) { frame in
                if animate {
                    let x = Int((frame.x / self.bounds.width) * 10)
                    let y = Int((frame.y / self.bounds.height) * 10)
                    
                    let cellWidth = self.bounds.width / 10
                    let cellHeight = self.bounds.height / 10
                    let newCenter = CGPoint(x: cellWidth * CGFloat(x) + frame.width / 2,
                                            y: cellHeight * CGFloat(y) + frame.height / 2)
                    let animation = CABasicAnimation(keyPath: "position")
                    animation.fromValue = frame.center
                    animation.toValue = newCenter
                    animation.duration = 0.2
                    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            //        animation.fillMode = .forwards
            //        animation.isRemovedOnCompletion = false
                    boatView.layer.add(animation, forKey: "position")
                }
                boatView.frame = frame
            }
        }
    }
}

//  MARK: - Private
private extension BattleFieldView {
    func attachViews() {
        [collectionView].forEach(addSubview)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureUI() {
        
    }
    
    func configureBindings() {
        dataSource.didSelect = { [weak self] _, indexPath in
            guard self?.isAbleToShoot?() ?? false else { return }
            self?.didShootPositionAt?(indexPath)
        }
    }
    
    func getBoatFrame(boat: Boat, cellWidth: CGFloat, cellHeight: CGFloat, completion: ((CGRect) -> Void)?) {
        DispatchQueue.global(qos: .userInitiated).async {
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
            DispatchQueue.main.async {
                let frame = CGRect(x: CGFloat(first.x - 1) * cellWidth, y: CGFloat(first.y - 1) * cellHeight, width: Constants.cellPadding + width, height: Constants.cellPadding + height)
                let insetFrame = frame.insetBy(dx: Constants.cellPadding, dy: Constants.cellPadding)
                completion?(insetFrame)
            }
        }
    }
}
