//
//  GameViewController.swift
//  SeaBattle
//
//  Created by Maks on 01.12.2020.
//

import UIKit
import SnapKit

final class GameViewController: BaseViewController<GameViewModel> {
    private lazy var firstUserGameView = GameView()
    private lazy var secondUserGameView = GameView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attachViews()
        configureUI()
        configureBindings()
    }
    
    override func performOnceInViewDidAppearOnLayoutUpdate() {
        let height = ((view.bounds.height - (view.safeAreaInsets.top + view.safeAreaInsets.bottom)) / 2) - 5
        let width = view.bounds.width
        firstUserGameView.snp.makeConstraints {
            $0.height.equalTo(min(height, width))
            $0.width.equalTo(min(width, height))
        }
        secondUserGameView.snp.makeConstraints {
            $0.height.equalTo(min(height, width))
            $0.width.equalTo(min(width, height))
        }
        DispatchQueue.main.async {
            self.firstUserGameView.configure(with: self.viewModel.firstUserBoats, positions: Array(self.viewModel.firstUserPositions))
            self.secondUserGameView.configure(with: self.viewModel.secondUserBoats, positions: Array(self.viewModel.secondUserPositions))
        }
    }
}

//  MARK: - Private
private extension GameViewController {
    func attachViews() {
        [firstUserGameView, secondUserGameView].forEach(view.addSubview)
        
        firstUserGameView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
        }
        
        secondUserGameView.snp.makeConstraints {
            $0.top.equalTo(firstUserGameView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
    
    func configureUI() {
        
    }
    
    func configureBindings() {
        viewModel.didReceivePositions = { [weak self] positions in
            guard let self = self else { return }
            self.firstUserGameView.configure(with: self.viewModel.firstUserBoats, positions: positions)
        }
        
        firstUserGameView.didShootPositionAt = { [weak self] indexPath in
            self?.viewModel.shoot(at: indexPath.item)
        }
    }
}
