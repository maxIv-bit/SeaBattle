//
//  RotateHintViewController.swift
//  SeaBattle
//
//  Created by Maks on 17.12.2020.
//

import UIKit

final class RotateHintViewController: BaseViewController<RotateHintViewModel> {
    private lazy var overlayView = UIView()
    private lazy var maskLayer = CAShapeLayer()
    private lazy var doubleTapImageView = UIImageView()
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecongizer))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attachViews()
        configureUI()
        configureBindings()
    }
    
    override func performOnceInViewDidAppear() {
        let path = UIBezierPath()
        path.append(UIBezierPath(rect: overlayView.frame))
        maskLayer.path = path.cgPath
        path.append(UIBezierPath(roundedRect: viewModel.boatFrame,
                                 cornerRadius: 10))
        overlayView.animatePath(from: maskLayer.path, to: path.cgPath, animationDuration: 0.2, assignToLayer: maskLayer, completion: nil)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.overlayView.alpha = 0.4
        }, completion: { _ in
            let scaleDecreaseAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
            scaleDecreaseAnimation.values = [CGAffineTransform(scaleX: 1.0, y: 1.0), CGAffineTransform(scaleX: 0.7, y: 0.7), CGAffineTransform(scaleX: 0.6, y: 0.6),  CGAffineTransform(scaleX: 0.7, y: 0.7), CGAffineTransform(scaleX: 0.6, y: 0.6)]
            scaleDecreaseAnimation.keyTimes = [0.0, 0.5, 0.6, 0.7, 0.8]
            scaleDecreaseAnimation.duration = 2.0
            scaleDecreaseAnimation.repeatCount = Float.infinity
            self.doubleTapImageView.layer.add(scaleDecreaseAnimation, forKey: "")
            UserDefaultManager.shared.showedHint = true
        })
    }
}

//  MARK: - Private
private extension RotateHintViewController {
    func attachViews() {
        [overlayView].forEach(view.addSubview)

        overlayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureUI() {
        overlayView.alpha = 0
        overlayView.backgroundColor = .black
        overlayView.clipsToBounds = true
        
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.fillRule = .evenOdd
        overlayView.layer.mask = maskLayer
        
        doubleTapImageView.tintColor = .red
        doubleTapImageView.image = UIImage(named: "tap")?.withRenderingMode(.alwaysTemplate)

        doubleTapImageView.frame = CGRect(origin: CGPoint(x: viewModel.boatFrame.x - 20, y: viewModel.boatFrame.y + 20), size: CGSize(width: 120, height: 120))
        view.addSubview(doubleTapImageView)
        
        view.addGestureRecognizer(tapGesture)
    }
    
    func configureBindings() {
        
    }
    
    @objc func tapGestureRecongizer(_ gesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.2, animations: {
            self.overlayView.alpha = 0
            self.doubleTapImageView.alpha = 0
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
}
