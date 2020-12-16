//
//  BoatView.swift
//  SeaBattle
//
//  Created by Maks on 10.12.2020.
//

import UIKit

final class BoatView: View {
    private lazy var stackView = UIStackView()
    private lazy var singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(singleTapGestureRegonizer))
    private lazy var doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapGestureRegonizer))
    private(set) var boat: Boat
    
    // MARK: - Callbacks
    var didUpdatePositions: ((String, [Position]) -> Void)?
    var didShootPosition: ((String, Position) -> Void)?
    
    init(boat: Boat, frame: CGRect,
         postionsObserver: ((String, [Position]) -> Void)?,
         shootObserver: ((String, Position) -> Void)?) {
        self.boat = boat
        
        super.init(frame: frame)
        
        didUpdatePositions = postionsObserver
        didShootPosition = shootObserver
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        attachViews()
        configureUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.superview?.bringSubviewToFront(self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let sv = superview,
            let touch = touches.first else { return }
        
        let parentFrame = sv.bounds
        
        let location = touch.location(in: self)
        let previousLocation = touch.previousLocation(in: self)
        
        var newFrame = self.frame.offsetBy(dx: location.x - previousLocation.x, dy: location.y - previousLocation.y)
        
        newFrame.origin.x = max(newFrame.origin.x, 0.0)
        newFrame.origin.x = min(newFrame.origin.x, parentFrame.size.width - newFrame.size.width)
        
        newFrame.origin.y = max(newFrame.origin.y, 0.0)
        newFrame.origin.y = min(newFrame.origin.y, parentFrame.size.height - newFrame.size.height)
        
        self.frame = newFrame
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let sv = superview else { return }
        translateFrameToPositions(sv: sv)
    }
    
    @objc func singleTapGestureRegonizer(_ gesture: UITapGestureRecognizer) {
        guard let sv = superview else { return }
        let location = gesture.location(in: sv)
        let cellWidth = sv.bounds.width / 10
        let cellHeight = sv.bounds.height / 10
        let x = Int(location.x / cellWidth) + 1
        let y = Int(location.y / cellHeight) + 1
        didShootPosition?(boat.id, Position(x: x, y: y, isShot: true))
    }
    
    @objc func doubleTapGestureRegonizer(_ gesture: UITapGestureRecognizer) {
        let boatPositions = boat.positions.values
        guard boatPositions.count > 1 else { return }
        
        let xPositions = Set(boat.positions.values.map { $0.x }).sorted(by: { $0 < $1 })
        let yPositions = Set(boat.positions.values.map { $0.y }).sorted(by: { $0 < $1 })
        if xPositions.count > yPositions.count {
            let x = xPositions.first!
            var y = yPositions.first!
            if y + xPositions.count > 10 {
                y = (10 - xPositions.count) + 1
            }
            var ys = [Int]()
            for i in 0..<xPositions.count {
                ys.append(y + i)
            }
            var positions = [Position]()
            for y in ys {
                positions.append(Position(x: x, y: y, isShot: false))
            }
            didUpdatePositions?(boat.id, positions)
        } else {
            let y = yPositions.first!
            var x = xPositions.first!
            if x + yPositions.count > 10 {
                x = (10 - yPositions.count) + 1
            }
            var xs = [Int]()
            for i in 0..<yPositions.count {
                xs.append(x + i)
            }
            var positions = [Position]()
            for x in xs {
                positions.append(Position(x: x, y: y, isShot: false))
            }
            didUpdatePositions?(boat.id, positions)
        }
    }
    
    func update(boat: Boat) {
        self.boat = boat
        configurePositions()
    }
}

//  MARK: - Private
private extension BoatView {
    func attachViews() {
        [stackView].forEach(addSubview(_:))
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        }
    }
    
    func configureUI() {
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.borderWidth = 5.0
        self.layer.cornerRadius = 10.0
        
        configurePositions()
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        
        singleTapGesture.numberOfTapsRequired = 1
        addGestureRecognizer(singleTapGesture)
        doubleTapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapGesture)
        singleTapGesture.require(toFail: doubleTapGesture)
    }
    
    func configurePositions() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let positions = Array(boat.positions.values).sorted(by: { $0.x < $1.x || $0.y < $1.y })
        if positions.count > 1 {
            if Set(positions.map({ $0.x })).count > Set(positions.map({ $0.y })).count {
                stackView.axis = .horizontal
            } else {
                stackView.axis = .vertical
            }
        } else {
            stackView.axis = .horizontal
        }
        positions.forEach { stackView.addArrangedSubview(UIImageView(image: $0.isHurt ? UIImage(named: "redX") : nil)) }
    }
    
    func translateFrameToPositions(sv: UIView) {
        isUserInteractionEnabled = false
        let cellWidth = sv.bounds.width / 10
        let cellHeight = sv.bounds.height / 10
        if frame.width > frame.height {
            var x = frame.x
            var xs = [Int]()
            while x < frame.x + frame.width {
                xs.append(Int(x / cellWidth) + 1)
                x += cellWidth
            }
            
            let y = Int(frame.y / cellHeight) + 1
            
            var positions = [Position]()
            for x in xs {
                positions.append(Position(x: x, y: y, isShot: false))
            }
            didUpdatePositions?(boat.id, positions)
        } else {
            var y = frame.y
            var ys = [Int]()
            while y < frame.y + frame.height {
                ys.append(Int(y / cellHeight) + 1)
                y += cellHeight
            }
            
            let x = Int(frame.x / cellWidth) + 1
            
            var positions = [Position]()
            for y in ys {
                positions.append(Position(x: x, y: y, isShot: false))
            }
            didUpdatePositions?(boat.id, positions)
        }
        isUserInteractionEnabled = true
    }
}
