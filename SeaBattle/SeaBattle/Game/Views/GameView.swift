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
    var didTapOnPosition: ((CGPoint) -> Void)?
    
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
}

//  MARK: - Private
private extension GameView {
    func configureBindings() {
        battleFieldView.didTapOnPosition = { [weak self] position in
            self?.didTapOnPosition?(position)
        }
    }
}
