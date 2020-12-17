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
        let right = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(rightBarButtonItemAction))
        navigationItem.rightBarButtonItem = right
        let back = UIBarButtonItem(title: "Leave", style: .plain, target: self, action: #selector(backBarButtonItemAction))
        navigationItem.leftBarButtonItem = back
    }
    
    func configureBindings() {
        viewModel.didReceiveFirstUserPositions = { [weak self] positions in
            self?.firstUserGameView.update(positions: positions)
        }
        
        viewModel.didUpdateFirstUserBoatPositions = { [weak self] boat, animate in
            self?.firstUserGameView.update(boat: boat, isShot: false, animate: animate)
        }
        
        viewModel.didShootFirstUserBoat = { [weak self] boat in
            self?.firstUserGameView.update(boat: boat, isShot: true, animate: false)
        }
        
        viewModel.didReceiveSecondUserPositions = { [weak self] positions in
            self?.secondUserGameView.update(positions: positions)
        }
        
        viewModel.didUpdateSecondUserBoatPositions = { [weak self] boat, animate in
            self?.secondUserGameView.update(boat: boat, isShot: false, animate: animate)
        }
        
        viewModel.didShootSecondUserBoat = { [weak self] boat in
            self?.secondUserGameView.update(boat: boat, isShot: true, animate: false)
        }
        
        firstUserGameView.didShootPositionAt = { [weak self] indexPath in
            self?.viewModel.shoot(at: indexPath.item)
        }
        
        firstUserGameView.didUpdateBoatPositions = { [weak self] boatId, positions in
            self?.viewModel.updateBoatPosition(boatId: boatId, positions: positions)
        }
        
        firstUserGameView.didShootBoatAtPosition = { [weak self] boatId, position in
            self?.viewModel.shootBoat(boatId: boatId, position: position)
        }
        
        firstUserGameView.isAbleToShoot = { [weak self] in
            self?.viewModel.isAbleToShoot(true) ?? false
        }
        
        firstUserGameView.shouldShowBoats = { [weak self] in
            self?.viewModel.shouldShowBoats(true) ?? false
        }
        
        firstUserGameView.isAbleToChangePositions = { [weak self] in
            self?.viewModel.isAbleToChangePositions(true) ?? false
        }
        
        firstUserGameView.onFirstBoatFrame = { [weak self] frame in
            self?.viewModel.showRotateHint(firstField: true, frame: frame)
        }
        
        secondUserGameView.didShootPositionAt = { [weak self] indexPath in
            self?.viewModel.shoot(at: indexPath.item)
        }
        
        secondUserGameView.didUpdateBoatPositions = { [weak self] boatId, positions in
            self?.viewModel.updateBoatPosition(boatId: boatId, positions: positions)
        }
        
        secondUserGameView.didShootBoatAtPosition = { [weak self] boatId, position in
            self?.viewModel.shootBoat(boatId: boatId, position: position)
        }
        
        secondUserGameView.isAbleToShoot = { [weak self] in
            self?.viewModel.isAbleToShoot(false) ?? false
        }
        
        secondUserGameView.isAbleToChangePositions = { [weak self] in
            self?.viewModel.isAbleToChangePositions(false) ?? false
        }
        
        secondUserGameView.shouldShowBoats = { [weak self] in
            self?.viewModel.shouldShowBoats(false) ?? false
        }
        
        secondUserGameView.onFirstBoatFrame = { [weak self] frame in
            self?.viewModel.showRotateHint(firstField: false, frame: frame)
        }
        
        viewModel.onError = { error in
            UIAlertController.showOkAlert(message: error, viewController: UIViewController.pvc())
        }
    }
    
    @objc func rightBarButtonItemAction(_ sender: UIBarButtonItem) {
        viewModel.ready()
    }
    
    @objc func backBarButtonItemAction(_ sender: UIBarButtonItem) {
        viewModel.disconnectFromRoom()
        navigationController?.popViewController(animated: true)
    }
}
