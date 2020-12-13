//
//  GameViewController.swift
//  SeaBattle
//
//  Created by Maks on 01.12.2020.
//

import UIKit

final class GameViewController: BaseViewController<GameViewModel> {
    private lazy var layout = PinterestLayout(data: [])
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    private lazy var dataSource = GameCollectionViewDataSource(collectionView: collectionView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attachViews()
        configureUI()
        configureBindings()
        
        let cellWidth = view.bounds.width / 10
        let cellHeight = view.bounds.height / 10
        for x in 1...10 {
            for y in 1...10 {
                let frame = CGRect(x: CGFloat(x - 1) * cellWidth, y: CGFloat(y - 1) * cellHeight, width: cellWidth, height: cellHeight)
                let newView = BattleFieldCellView(x: x, y: y, frame: frame)
                view.addSubview(newView)
            }
        }
    }
}

//  MARK: - Private
private extension GameViewController {
    func attachViews() {
        [collectionView].forEach(view.addSubview)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    func configureUI() {
        navigationController?.navigationBar.tintColor = .white
    }
    
    func configureBindings() {
        viewModel.didReceieveFieldCells = { [weak self] fieldCells in
            self?.layout.data = fieldCells
            self?.dataSource.update(data: fieldCells, shouldReload: true)
        }
        
        viewModel.didReceieveBoats = { [weak self] boats in
            self?.configureBoatViews(boats)
        }
    }
    
    func configureBoatViews(_ boats: [Boat]) {
        let cellPadding: CGFloat = 2
        for boat in boats.sorted(by: { $0.positions.values.first?.x ?? 0 < $1.positions.values.first?.x ?? 0 }) {
            let boatPositions = boat.positions.values.sorted(by: { $0.x < $1.x || $0.y < $1.y }).map { Position(x: $0.x, y: $0.y) }
            let first = boatPositions.first!
            var width: CGFloat = view.bounds.width / 10
            var height: CGFloat = view.bounds.height / 10
            if boatPositions.count > 1 {
                if Set(boatPositions.map({ $0.x })).count > Set(boatPositions.map({ $0.y })).count {
                    width = CGFloat(boatPositions.count) * width
                } else {
                    height = CGFloat(boatPositions.count) * height
                }
            }
            let frame = CGRect(x: CGFloat(first.x - 1) * (view.bounds.width / 10), y: CGFloat(first.y - 1) * (view.bounds.height / 10), width: cellPadding + width, height: cellPadding + height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            let newView = BoatView(boat: boat, frame: insetFrame)
            view.addSubview(newView)
        }
    }
}
