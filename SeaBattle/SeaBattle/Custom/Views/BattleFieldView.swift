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
    
    // MARK: - Callback
    var didShootPositionAt: ((IndexPath) -> Void)?
    
    override func configure() {
        attachViews()
        configureUI()
        configureBindings()
    }
    
    func configure(with boats: [Boat], positions: [Position]) {
        dataSource.update(data: positions, shouldReload: true)
        
        let cellWidth: CGFloat = self.bounds.width / 10
        let cellHeight: CGFloat = self.bounds.height / 10
        
        DispatchQueue.global().async {
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
            self?.didShootPositionAt?(indexPath)
        }
    }
}
