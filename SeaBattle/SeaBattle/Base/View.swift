//
//  View.swift
//  SeaBattle
//
//  Created by Maks on 13.12.2020.
//

import UIKit

class View: UIView {
    private lazy var layoutSubviewsWasCalled = false
    func performOnceOnLayoutSubviews() { }
    func configure() {}
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !layoutSubviewsWasCalled {
            performOnceOnLayoutSubviews()
            layoutSubviewsWasCalled.toggle()
        }
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configure()
    }
}
