//
//  GameViewController.swift
//  SeaBattle
//
//  Created by Maks on 01.12.2020.
//

import UIKit

final class GameViewController: BaseViewController<GameViewModel> {
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var dataSource = GameCollectionViewDataSource(collectionView: collectionView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attachViews()
        configureUI()
        configureBindings()
    }
}

//  MARK: - Private
private extension GameViewController {
    func attachViews() {
        [collectionView].forEach(view.addSubview)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureUI() {
        
    }
    
    func configureBindings() {
        viewModel.didReceieveFieldCells = { [weak self] fieldCells in
            self?.dataSource.update(data: fieldCells, shouldReload: true)
        }
    }
}
