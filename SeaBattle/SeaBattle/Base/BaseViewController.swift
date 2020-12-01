//
//  BaseViewController.swift
//  SeaBattle
//
//  Created by Maks on 17.11.2020.
//

import UIKit
import SnapKit
import StoreKit

private struct Constants {
    static var navigationBarHeight: CGFloat { 70.0 }
    static var timeInterval: TimeInterval { 2.0 }
    static var animationDuration: TimeInterval { 0.25 }
    static var offlineModeHeight: CGFloat { 20.0 }
}

class BaseViewController<T: BaseViewModel>: UIViewController {
    private lazy var viewWillAppearWasCalled = false
    private lazy var viewDidAppearWasCalled = false
    private lazy var onScreen = false
    
    let viewModel: T
    
    override func loadView() {
        self.view = UIView(frame: CGRect(origin: .zero, size: UIScreen.main.bounds.size))
    }
    
    required init(viewModel: T) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        extendedLayoutIncludesOpaqueBars = true
        automaticallyAdjustsScrollViewInsets = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defer {
            viewWillAppearWasCalled = true
        }
        
        if !self.viewWillAppearWasCalled {
            viewModel.launch()
            performOnceInViewWillAppear()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        defer {
            viewDidAppearWasCalled = true
        }
        
        if !self.viewDidAppearWasCalled {
            performOnceInViewDidAppear()
            view.layoutIfNeeded()
            performOnceInViewDidAppearOnLayoutUpdate()
        }
    }
    
    // MARK: - Override point
    func performOnceInViewWillAppear() {}
    func performOnceInViewDidAppear() {}
    func performOnceInViewDidAppearOnLayoutUpdate() { }
    func shouldShowOfflineMode() -> Bool { true }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("☠️\(self)☠️")
    }
}
